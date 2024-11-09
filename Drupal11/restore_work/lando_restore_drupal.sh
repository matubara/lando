
source ../../const_lando_builddrupal.sh 

if [ $# -eq 3 ]; then
    drupalproj=$1
    drupalproj_old=$2
    backupname=$3
    echo "Drupal project名は次の通りです"
    echo "現在のDrupal project名： ${drupalproj} "
    echo "転送元（バックアップファイル内）のDrupal project名： ${drupalproj_old} "
    echo "バックアップファイル名：${backupname}"
    if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

else
    echo "${RED}【警告】引数が不正です${RESET}";
    echo "${RED}第一引数：現在のDrupal project名${RESET}";
    echo "${RED}第二引数：転送元（バックアップファイル内）のDrupal project名${RESET}";
    echo "${RED}第三引数：バックアップファイル名${RESET}";
    echo "${RED}処理を中断します${RESET}";
    exit 1
fi


#Drupalプロジェクトフォルダ名
#getparameters.shから取得したフォルダ名を使用する
#VPSと共用版を作成する場合は要検討
#drupalproj=${name}

#バックアップファイル内の転送元Drupalプロジェクトフォルダ名
#drupalproj_old=chatgpt100

#Drupalプロジェクトパス
projpath=/home/matsubara/${profile}/${drupalproj}
#Drupalプロジェクト内ワークパス
workpath=/home/matsubara/${profile}/${drupalproj}/restore_work
#WEBパス
webpath=${projpath}/web
#VENDORパス
vendorpath=${projpath}/vendor

backupfile=${backupname}.tar.gz
backupdb=${backupname}.sql

if [ ! -d ${projpath} ]; then
  echo "${RED}【警告】Drupal projectフォルダが存在しません${RESET}";
  echo "${RED}処理を中断します${RESET}";
  exit 1;
fi
if [ -f ${workpath}/${backupfile} ]; then
  echo "${GREEN}【passed】インポート対象ファイル ${backupfile} が見つかりました${RESET}";
else
  echo "${RED}インポート対象ファイル ${backupfile} が存在しません。${RESET}";
  echo "処理を中断します。";
  exit 1;
fi
if [ -f ${workpath}/${backupdb} ]; then
  echo "${GREEN}【passed】インポート対象DBファイル ${backupdb} が見つかりました${RESET}";
else
  echo "${RED}インポート対象DBファイル ${backupdb} が存在しません${RESET}";
  echo "${RED}処理を中断します${RESET}";
  exit 1;
fi

echo "${GREEN}【Drupal】環境構築 KUSANAGI環境 初期化コマンド実行します${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

if [ -f ${webpath}/sites/default/settings.php ]; then
  echo "${GREEN}設定ファイルのバックアップします${RESET}"
  if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
  sudo mv -f ${webpath}/sites/default/settings.php ${projpath} 
fi

echo "${GREEN}ファイルを展開します${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
tar zxf ${workpath}/${backupfile}

if [ ! -d ${workpath}/${drupalproj_old} ]; then
  echo "${RED}【警告】バックアップファイル（転送元）に対象のDrupal Projectフォルダが存在しません${RESET}";
  echo "${RED}処理を中断します${RESET}";
  exit 1;
fi

echo "バックアップファイル（転送元）内の設定ファイルを削除する"
sudo rm -f ${workpath}/${drupalproj_old}/web/sites/default/settings.php


echo VENDER,WEBフォルダ、COMPOSERファイルをBAKフォルダに移動する
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
sudo rm -rf ${projpath}/bak
sudo mkdir ${projpath}/bak
sudo mv  ${webpath} ${projpath}/bak
sudo mv  ${vendorpath} ${projpath}/bak
sudo mv  ${projpath}/composer.json ${projpath}/bak
sudo mv  ${projpath}/composer.lock ${projpath}/bak

echo バックアップファイルのWEB,VENDERフォルダとCOMPSER.*ファイルを元に場所にコピーする
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
sudo mv -f ${workpath}/${drupalproj_old}/web ${projpath}
sudo mv -f ${workpath}/${drupalproj_old}/vendor ${projpath}
sudo cp -f ${workpath}/${drupalproj_old}/composer.* ${projpath}

echo "退避済みの設定ファイルを元に場所に戻す"
sudo cp -f ${projpath}/settings.php ${webpath}/sites/default/ 
echo 所有者、権限を変更する
sudo chmod 777 ${webpath} -R
sudo chmod 777 ${vendorpath} -R

echo "${GREEN}データベースをリストアします${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
#次のいずれかの方法でデータベースのインポートが可能
lando db-import ${backupdb}
#lando mysql -u drupal10 -pdrupal10 -h database drupal10 < ${workpath}/${backupdb}

echo "${GREEN}アプリのインストールを完了しました${RESET}"
