# wp-config.phpのTABLE PREFIXを変更する
# .htaccessファイルをドキュメントルートに設置する
name=$1

 pushd ./${name}/webroot
 pwd
 cp  ../../../archives/20221203_200039* ./
 sed -i s/\'wp_\'/\'bz_\'/g ./wp-config.php

 #install .htaccess file 
 cp  ../.lando_conf/wordpress/.htaccess ./ 

#read -p "Press [Enter] key to move on to the next."

 lando wp db import ./20221203_200039_MYSQL_DATABASE.sql
#read -p "Press [Enter] key to move on to the next."
 lando wp search-replace  "https://blogdeoshiete.com" "https://${name}-app.lndo.site"
 lando wp search-replace  "http://blogdeoshiete.com" "https://${name}-app.lndo.site"
 lando wp search-replace  "blogdeoshiete.com" "${name}-app.lndo.site"
#read -p "Press [Enter] key to move on to the next."

 SOURCECODE_UPLOADS=20221203_200039_WP_UPLOADS.tar.gz
 SOURCECODE_PLUGINS=20221203_200039_WP_PLUGINS.tar.gz
 SOURCECODE_THEMES=20221203_200039_WP_THEMES.tar.gz
 tar zxvf ./${SOURCECODE_UPLOADS}  > /dev/null 2>&1 
 tar zxvf ./${SOURCECODE_PLUGINS}  > /dev/null 2>&1 
 tar zxvf ./${SOURCECODE_THEMES}   > /dev/null 2>&1 
#read -p "Press [Enter] key to move on to the next."
 cp -rp ./uploads ./wp-content 
 cp -rp ./plugins ./wp-content 
 cp -rp ./themes ./wp-content 
#read -p "Press [Enter] key to move on to the next."
 rm -rf ./uploads
 rm -rf ./plugins 
 rm -rf ./themes 

 popd
