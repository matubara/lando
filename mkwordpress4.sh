#!/usr/bin/bash
if [ $# -eq 0 ];then
    #プロンプトをechoを使って表示
    echo -n foldername=
    #入力を受付、その入力を「str」に代入
    read name
    echo "フォルダ名は ${name} でよろしいですか？"
    read -p "ok? (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
elif [ $# -eq 1 ];then
    name=$1
else
    echo "引数が不正です"
    exit 1
fi

    echo "現在起動中のコンテナをすべて停止する"
    docker stop $(docker ps -q)

#webrootフォルダ名をここで指定する
webroot=webroot

# Create folder and enter it
mkdir ${name} && cd ${name}

# Copy lando_conf to current folder
cp -rf ../lando_conf ./.lando_conf

# Initialize a wordpress recipe using the latest WordPress version
lando init \
  --source remote \
  --remote-url https://wordpress.org/latest.tar.gz \
  --recipe wordpress \
  --webroot ${webroot} \
  --name ${name}-app


echo "Rename webroot folder name to ${webroot}."
mv ./wordpress ./${webroot}

# Add xdebug service to .lando.yml
echo "Add xdebug service to .lando.yml"
sed -i "/webroot:/a \  xdebug: true\n  config:\n    php: .lando_conf/php.ini" .lando.yml



echo "Add phpAdmin service"

echo "" >> .lando.yml
echo "services:" >> .lando.yml
echo "  appserver:" >> .lando.yml
echo "    overrides:" >> .lando.yml
echo "      extra_hosts:" >> .lando.yml
echo "        - ${LANDO_HOST_NAME_DEV:-host}:${LANDO_HOST_GATEWAY_DEV:-host-gateway}" >> .lando.yml
echo "  phpmyadmin:" >> .lando.yml
echo "    type: phpmyadmin" >> .lando.yml
echo "    hosts:" >> .lando.yml
echo "      - database" >> .lando.yml


echo "Rebuild docker based on .lando.yml"
# Rebuild it
lando rebuild -y

echo "Start it up"
# Start it up
lando start


# List information about this app
lando info


# Create a WordPress config file
lando wp config create \
  --dbname=wordpress \
  --dbuser=wordpress \
  --dbpass=wordpress \
  --dbhost=database \
  --path=${webroot}


# Install WordPress
lando wp core install \
  --url=https://${name}-app.lndo.site/ \
  --title="${name} App" \
  --admin_user=sinceretechnology \
  --admin_password=Melb#1999 \
  --admin_email=admin@sinceretechnology.com.au \
  --path=${webroot}

