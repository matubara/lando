STEPMODE=false

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
    echo "フォルダ名は ${name} でよろしいですか？"
    read -p "ok? (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
else
    echo "引数が不正です"
    exit 1
fi

####################################################
# kusanagiプロビジョニングとDrupalインストール実施 #
####################################################

# 表示用制御文字の設定
ESC=$(printf '\033') RESET="${ESC}[0m"

BOLD="${ESC}[1m"        FAINT="${ESC}[2m"       ITALIC="${ESC}[3m"
UNDERLINE="${ESC}[4m"   BLINK="${ESC}[5m"       FAST_BLINK="${ESC}[6m"
REVERSE="${ESC}[7m"     CONCEAL="${ESC}[8m"     STRIKE="${ESC}[9m"
GOTHIC="${ESC}[20m"     DOUBLE_UNDERLINE="${ESC}[21m" NORMAL="${ESC}[22m"
NO_ITALIC="${ESC}[23m"  NO_UNDERLINE="${ESC}[24m"     NO_BLINK="${ESC}[25m"
NO_REVERSE="${ESC}[27m" NO_CONCEAL="${ESC}[28m"       NO_STRIKE="${ESC}[29m"
BLACK="${ESC}[30m"      RED="${ESC}[31m"        GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"     BLUE="${ESC}[34m"       MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"       WHITE="${ESC}[37m"      DEFAULT="${ESC}[39m"
BG_BLACK="${ESC}[40m"   BG_RED="${ESC}[41m"     BG_GREEN="${ESC}[42m"
BG_YELLOW="${ESC}[43m"  BG_BLUE="${ESC}[44m"    BG_MAGENTA="${ESC}[45m"
BG_CYAN="${ESC}[46m"    BG_WHITE="${ESC}[47m"   BG_DEFAULT="${ESC}[49m"

CONFIRMMES="${RED}よろしいですか？ENTERキーを押してください。次に進みます。${RESET}"

profile=lando
drupalproj=${name}
#Drupalプロジェクトパス
projpath=/home/matsubara/${profile}/${drupalproj}
webpath=${projpath}/web
vendorpath=${projpath}/vendor
backupfile=./20241027_041002_chatgpt100.tar.gz
backupdb=./20241027_041002_chatgpt100.sql


echo "【Drupal】環境構築 KUSANAGI環境 初期化コマンド実行"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi



echo 設定ファイルのバックアップを取る
ls ${webpath}/sites/default/settings.php 
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
sudo mv -f ${webpath}/sites/default/settings.php ${projpath} 
echo ファイルを展開する
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
tar zxf ${backupfile}
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

echo 退避済みの設定ファイルを元に場所に戻す
cp -f ${projpath}/settings.php ${webpath}/sites/default/ 
echo 所有者、権限を変更する
sudo chmod 777 ${webpath} -R
sudo chmod 777 ${vendorpath} -R

echo データベースをリストアする
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
lando db-import ${backupdb}

echo "アプリのインストールを完了しました"
