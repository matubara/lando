# wp-config.phpのTABLE PREFIXを変更する
# .htaccessファイルをドキュメントルートに設置する
name=$1

 pushd ./${name}
 pwd

#デバッグ環境の設定
cp -rf ./.lando_conf/drupal9/settings.local.php ./web/sites/default/
cp -rf ./.lando_conf/drupal9/development.services.yml ./web/sites/

#echo "" >> ./web/sites/default/settings.php
#echo "if (file_exists($app_root . '/' . $site_path . '/settings.local.php')) {" >> ./web/sites/default/settings.php
#echo "  include $app_root . '/' . $site_path . '/settings.local.php';" >> ./web/sites/default/settings.php
#echo "}" >> ./web/sites/default/settings.php


#バックアップファイルをプロジェクトルートに展開する
echo "copy source code from archive folder"
cp ../../archives/02AUG2022NEWDEMO.sql ./
cp ../../archives/sazae-toyo-lms-03082022.zip ./
unzip ./sazae-toyo-lms-03082022.zip

#read -p "Press [Enter] key to move on to the next."
mv ./sazae-toyo-lms/* ./
mv ./sazae-toyo-lms/.e* ./
mv ./sazae-toyo-lms/.g* ./
mv ./sazae-toyo-lms/.h* ./
mv ./sazae-toyo-lms/.t* ./
sudo cp -rf ./sazae-toyo-lms/web/ ./

#read -p "Press [Enter] key to move on to the next."
sudo chmod 777 web -R

#read -p "Press [Enter] key to move on to the next."
mkdir bak
cp -r ./web ./bak

echo "composer install"
#read -p "Press [Enter] key to move on to the next."
lando composer install


#read -p "Press [Enter] key to move on to the next."
cp ./web/core/assets/scaffold/files/htaccess ./web/.htaccess
cp -rf ./web/core/assets/scaffold/files/default.services.yml ./web/sites/default/
cp -rf ./web/core/assets/scaffold/files/default.settings.php ./web/sites/default/

#read -p "Press [Enter] key to move on to the next."
cp -rf ./bak/web/ ./

echo "import database"
#read -p "Press [Enter] key to move on to the next."
lando db-import ./02AUG2022NEWDEMO.sql



echo "import media file"
#read -p "Press [Enter] key to move on to the next."
cp ../../archives/03082022files.tar.gz ./web/sites/default/ 
popd

pushd ./${name}/web/sites/default
tar zxfmp 03082022files.tar.gz
popd

echo "cache clear"
#read -p "Press [Enter] key to move on to the next."
 pushd ./${name}
lando drush cr
popd

