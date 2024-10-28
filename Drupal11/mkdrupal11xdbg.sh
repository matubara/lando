#!/usr/bin/bash
#constファイルの読み込み
source ./const_lando_builddrupal.sh

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
elif [ $# -eq 2 ] && [ $2 = "drupal10" ]; then
    name=$1
    drupalver=${d10_drupalver}
    phpver=${d10_phpver}
    dbver=${d10_dbver}
elif [ $# -eq 2 ] && [ $2 = "drupal11" ]; then
    name=$1
    drupalver=${d11_drupalver}
    phpver=${d11_phpver}
    dbver=${d11_dbver}
else
    echo "引数が不正です"
    exit 1
fi

    echo "現在起動中のコンテナをすべて停止する"
    docker stop $(docker ps -q)

#webrootフォルダ名をここで指定する
webroot=web

#LOGINアカウント設定
adminuser=admin
adminpass=admin

#デバッグON/OFF
XDEBUGFLG=true


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

CONFIRMMES="${RED}よろしければENTERキーを押してください。次に進みます。${RESET}"



if [ -d ./${name} ]; then
  echo "既にフォルダが存在します。";
  echo "処理を中断します。";
  exit 1;
fi

echo "${name} ディレクトリを作成します";
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

# Create folder and enter it
mkdir ${name} && cd ${name}

pwd
echo "lando initを実行して良いですか"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

# Copy lando_conf to current folder
rm -rf ./.lando_conf
cp -rf ../lando_conf ./.lando_conf

# Initialize a drupal9 recipe

  lando init \
    --source cwd \
    --recipe ${recipe} \
    --webroot ${webroot} \
    --name ${name} 


# Add xdebug service to .lando.yml
echo "Add xdebug service to .lando.yml"
sed -i "/webroot:/a \  xdebug: ${XDEBUGFLG}\n  php: ${phpver}\n  database: ${dbver}\n  config:\n    php: .lando_conf/php.ini" .lando.yml


echo "Add phpAdmin service"

echo "" >> .lando.yml
echo "services:" >> .lando.yml
echo "  appserver:" >> .lando.yml
echo "    overrides:" >> .lando.yml
echo "      extra_hosts:" >> .lando.yml
echo '        - ${LANDO_HOST_NAME_DEV:-host}:${LANDO_HOST_GATEWAY_DEV:-host-gateway}' >> .lando.yml
# echo "  myservice:" >> .lando.yml
# echo "    type: mysql:8.0" >> .lando.yml
echo "  phpmyadmin:" >> .lando.yml
echo "    type: phpmyadmin" >> .lando.yml
echo "    hosts:" >> .lando.yml
# echo "      - myservice" >> .lando.yml
echo "      - database" >> .lando.yml

echo "lando再構築しますが、よろしいですか？"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

echo "Rebuild docker based on .lando.yml"
# Rebuild it
lando rebuild -y


echo "Start it up"
# Start it up
  
    
# Create latest drupal9 project via composer
echo "lando composer create-project drupal/recommended-project${drupalver} tmp && cp -r tmp/. . && rm -rf tmp"
echo "Drupal setupしますが、よろしいですか？"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
lando composer create-project drupal/recommended-project${drupalver} tmp && cp -r tmp/. . && rm -rf tmp

echo "Drupal Installしますが、よろしいですか？"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

# Start it up
lando start

# Install a site local drush
lando composer require drush/drush

# Install drupal
# drush si --db-url=mysql://root:pass@localhost:port/dbname
#lando drush site:install --db-url=mysql://mysql:mysql@myservice:3306/database \
lando drush site:install --db-url=mysql://${recipe}:${recipe}@database/${recipe} \
        --account-name=${adminuser} \
        --account-pass=${adminpass} \
	-y

# List information about this app
lando info

