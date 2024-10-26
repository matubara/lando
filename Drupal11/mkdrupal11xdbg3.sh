#!/usr/bin/bash
#recipe=drupal10
recipe=lamp
#drupalver=:11.0.5
drupalver=
phpver=8.3
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
    drupalver=:10.3.6
    phpver=8.1
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

# Create folder and enter it
mkdir ${name} && cd ${name}

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
#sed -i "/webroot:/a \  xdebug: ${XDEBUGFLG}\n  php: 8.3\n  database: mysql:8.0\n  config:\n    php: .lando_conf/php.ini\n" .lando.yml
sed -i "/webroot:/a \  xdebug: ${XDEBUGFLG}\n  php: 8.3\n  config:\n    php: .lando_conf/php.ini\n" .lando.yml


echo "Add phpAdmin service"

echo "" >> .lando.yml
echo "services:" >> .lando.yml
echo "  appserver:" >> .lando.yml
echo "    overrides:" >> .lando.yml
echo "      extra_hosts:" >> .lando.yml
echo '        - ${LANDO_HOST_NAME_DEV:-host}:${LANDO_HOST_GATEWAY_DEV:-host-gateway}' >> .lando.yml
echo "  myservice:" >> .lando.yml
echo "    type: mysql:8.0" >> .lando.yml
echo "  phpmyadmin:" >> .lando.yml
echo "    type: phpmyadmin" >> .lando.yml
echo "    hosts:" >> .lando.yml
echo "      - myservice" >> .lando.yml
#echo "      - database" >> .lando.yml

#echo "lando再構築しますが、よろしいですか？"
#read -p "ok? (y/N): " yn

echo "Rebuild docker based on .lando.yml"
# Rebuild it
lando rebuild -y


echo "Start it up"
# Start it up
  
echo "Drupal installしますが、よろしいですか？"
read -p "ok? (y/N): " yn
    
# Create latest drupal9 project via composer
lando composer create-project drupal/recommended-project${drupalver} tmp && cp -r tmp/. . && rm -rf tmp

# Start it up
lando start

# Install a site local drush
lando composer require drush/drush

echo "Drupal setupしますが、よろしいですか？"
read -p "ok? (y/N): " yn

# Install drupal
# drush si --db-url=mysql://root:pass@localhost:port/dbname
#lando drush site:install --db-url=mysql://${recipe}:${recipe}@database/${recipe} \
lando drush site:install --db-url=mysql://mysql:mysql@myservice:3306/database \
        --account-name=${adminuser} \
        --account-pass=${adminpass} \
	-y
#lando drush site:install --db-url=mysql://${recipe}:${recipe}@database/${recipe} \
#        --account-name=${adminuser} \
#        --account-pass=${adminpass} \
#	-y

# List information about this app
lando info

