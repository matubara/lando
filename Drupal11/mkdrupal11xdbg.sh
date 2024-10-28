#!/usr/bin/bash

###############################################################
#下記変数の入力と、定数の読み込み
#name, DRUPALSET 
#定数読み込みの順序に注意すること
# ※ DRUPALSETの値により読み込まれる定数の内容が変わる
###############################################################
if [ $# -eq 0 ];then
    #プロンプトをechoを使って表示
    echo -n foldername=
    #入力を受付、その入力を「name」に代入
    read name
    #デフォルト値設定
    DRUPALSET=drupal10
elif [ $# -eq 1 ]; then
    name=$1
    #デフォルト値設定
    DRUPALSET=drupal10
elif [ $# -eq 2 ] && [ $2 = "drupal10" ]; then
    name=$1
    DRUPALSET=$2
elif [ $# -eq 2 ] && [ $2 = "drupal11" ]; then
    name=$1
    DRUPALSET=$2
else
    echo "引数が不正です"
    exit 1
fi

###############################################################
#constファイルの読み込み
source ./const_lando_builddrupal.sh
###############################################################

######################################################
if "${STEPMODE}"; then
    echo "【確認】設定内容を確認してください"
    echo "フォルダ名: ${name}"
    echo "Drupalバージョン: ${DRUPALSET}"
    read -p "よろしければ(y)、中断する場合は(N)を押してください (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
fi
######################################################


    echo "現在起動中のコンテナをすべて停止する"
    docker stop $(docker ps -q)

#webrootフォルダ名をここで指定する
webroot=web

#LOGINアカウント設定
adminuser=admin
adminpass=admin

#デバッグON/OFF
XDEBUGFLG=true



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

