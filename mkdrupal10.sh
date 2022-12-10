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
webroot=web

#LOGINアカウント設定
adminuser=admin
adminpass=admin

# Create folder and enter it
mkdir ${name} && cd ${name}


# Initialize a drupal9 recipe

  lando init \
    --source cwd \
    --recipe drupal10 \
    --webroot ${webroot} \
    --name ${name} 
    
# Create latest drupal9 project via composer
#lando composer create-project drupal/recommended-project:9.x tmp && cp -r tmp/. . && rm -rf tmp
lando composer create-project -n drupal/recommended-project:10.0.x-dev@dev tmp && cp -r tmp/. . && rm -rf tmp
# Start it up
lando start

# Install a site local drush
lando composer require drush/drush

# Install drupal
lando drush site:install --db-url=mysql://drupal10:drupal10@database/drupal10 \
        --account-name=${adminuser} \
        --account-pass=${adminpass} \
	-y

# List information about this app
lando info

