
source ../../const_lando_builddrupal.sh 

if [ $# -eq 0 ];then
    #プロンプトをechoを使って表示
    echo -n foldername=
    #入力を受付、その入力を「str」に代入
    read name
    echo "フォルダ名は ${name} でよろしいですか？"
    read -p "ok? (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

elif [ $# -eq 1 ]; then
    name=$1
    echo "フォルダ名は ${name} です"
    if "${STEPMODE}"; then
      read -p "ok? (y/N): " yn
      case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
    fi
else
    echo "引数が不正です"
    exit 1
fi

#変数の定義
#Drupalプロジェクトフォルダ名
drupalproj=${name}
#Drupalプロジェクトパス
projpath=/home/matsubara/${profile}/${drupalproj}
#WEBパス
webpath=${projpath}/web
#VENDORパス
vendorpath=${projpath}/vendor

if [ -d ./${projpath} ]; then
  echo "${RED}【警告】既にフォルダが存在します。${RESET}";
  echo "${RED}処理を中断します${RESET}";
  exit 1;
fi
if [ -f ./${backupfile} ]; then
  echo "${GREEN}【passed】インポート対象ファイル ${backupfile} が見つかりました${RESET}";
else
  echo "${RED}インポート対象ファイル ${backupfile} が存在しません。${RESET}";
  echo "処理を中断します。";
  exit 1;
fi
if [ -f ./${backupdb} ]; then
  echo "${GREEN}【passed】インポート対象DBファイル ${backupdb} が見つかりました${RESET}";
else
  echo "${RED}インポート対象DBファイル ${backupdb} が存在しません${RESET}";
  echo "${RED}処理を中断します${RESET}";
  exit 1;
fi

echo "${GREEN}【Drupal】環境構築 KUSANAGI環境 初期化コマンド実行します${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi



echo "${GREEN}設定ファイルのバックアップします${RESET}"
ls ${webpath}/sites/default/settings.php 
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
sudo mv -f ${webpath}/sites/default/settings.php ${projpath} 
echo "${GREEN}ファイルを展開します${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
tar zxf ./${backupfile}
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
mv -f ./chatgpt100/web ${projpath}
mv -f ./chatgpt100/vendor ${projpath}
cp -f ./chatgpt100/composer.* ${projpath}

echo "退避済みの設定ファイルを元に場所に戻す"
cp -f ${projpath}/settings.php ${webpath}/sites/default/ 
echo 所有者、権限を変更する
sudo chmod 777 ${webpath} -R
sudo chmod 777 ${vendorpath} -R

echo "${GREEN}データベースをリストアします${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
lando db-import ./${backupdb}

echo "${GREEN}アプリのインストールを完了しました${RESET}"
