#!/usr/bin/bash

######################################################
# パラメータを変数に取り込む          
source ./getparameters.sh
######################################################

######################################################
#constファイルの読み込み
source ./const_lando_builddrupal.sh
######################################################

######################################################
if "${STEPMODE}"; then
    echo "【確認】設定内容を確認してください"
    echo "現在のDrupal Project フォルダ名: ${drupalproj}"
    echo "バックアップファイル（転送元）のDrupal Project フォルダ名: ${drupalproj_old}"
    echo "Drupalバージョン: ${DRUPALSET}"
    read -p "よろしければ(y)、中断する場合は(N)を押してください (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
fi
######################################################


#webrootフォルダ名をここで指定する
webroot=web

#LOGINアカウント設定
adminuser=admin
adminpass=admin

#デバッグON/OFF
XDEBUGFLG=true



if [ -d ./${drupalproj} ]; then
  echo "${RED}既にフォルダが存在します。${RESET}";
  echo "${RED}処理を中断します。${RESET}";
  exit 1;
fi

echo "${YELLOW}${drupalproj} SUDO権限で実行するためパスワードを入力してください${RESET}";
sudo ls

echo "現在起動中のコンテナをすべて停止する"
docker stop $(docker ps -q)


echo "${GREEN}${drupalproj} ディレクトリを作成します${RESET}";
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

# Create folder and enter it
mkdir ${drupalproj} && cd ${drupalproj}

pwd
echo "${GREEN}lando 設定ファイルを作成します${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

# Copy lando_conf to current folder
rm -rf ./.lando_conf
cp -rf ../lando_conf ./.lando_conf

rm -f ./php.ini

 echo "[PHP]" >> ./php.ini
 echo "" >> ./php.ini
 echo "; Xdebug" >> ./php.ini
 echo "xdebug.max_nesting_level = 256" >> ./php.ini
 echo "xdebug.show_exception_trace = 0" >> ./php.ini
 echo "xdebug.collect_params = 0" >> ./php.ini
 echo "xdebug.mode = debug" >> ./php.ini
 echo "xdebug.client_port = 9001" >> ./php.ini
 echo "xdebug.start_with_request = yes" >> ./php.ini
 echo "xdebug.client_host = ${LANDO_HOST_IP}" >> ./php.ini
 echo "xdebug.idekey = \"PHPSTORM\"" >> ./php.ini
 echo "; xdebug.log = /tmp/xdebug.log" >> ./php.ini
 echo "" >> ./php.ini
 echo "; xdebug.remote_connect_back = 1" >> ./php.ini
 echo "; xdebug.remote_log = /tmp/xdebug_remote.log" >> ./php.ini



# Initialize a drupal9 recipe

  lando init \
    --source cwd \
    --recipe ${recipe} \
    --webroot ${webroot} \
    --name ${drupalproj} 


# Add xdebug service to .lando.yml
echo "Add xdebug service to .lando.yml"
sed -i "/webroot:/a \  xdebug: ${XDEBUGFLG}\n  php: ${phpver}\n  database: ${dbver}\n  config:\n    php: ./php.ini" .lando.yml


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

echo "${GREEN}lando 環境を構築します${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi

echo "Rebuild docker based on .lando.yml"
# Rebuild it
lando rebuild -y


echo "Start it up"
# Start it up
  
    
# Create latest drupal9 project via composer
echo "lando composer create-project drupal/recommended-project${drupalver} tmp && cp -r tmp/. . && rm -rf tmp"
echo "${GREEN}Drupal をインストールします${RESET}"
if "${STEPMODE}"; then read -p ${CONFIRMMES}; fi
lando composer create-project drupal/recommended-project${drupalver} tmp && cp -r tmp/. . && rm -rf tmp

echo "${GREEN}Drupal をセットアップします${RESET}"
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

