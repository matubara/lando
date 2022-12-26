# wp-config.phpのTABLE PREFIXを変更する
# .htaccessファイルをドキュメントルートに設置する
name=$1
src_domain=drupal10.xyz
src_prefix=20221227_010525

 pushd ./${name}/webroot
 pwd
 #cp  ../../../archives/20221203_200039* ./
 cp  ../../../archives/${src_prefix}* ./
 sed -i s/\'wp_\'/\'bz_\'/g ./wp-config.php

 #install .htaccess file 
 rm -f ./.htaccess
 cp  ../.lando_conf/wordpress/htaccess ./.htaccess

#read -p "Press [Enter] key to move on to the next."

 lando wp db import ./${src_prefix}_MYSQL_DATABASE.sql
#read -p "Press [Enter] key to move on to the next."
 lando wp search-replace  "${src_domain}" "${name}-app.lndo.site"
 lando wp search-replace  "http://${name}-app.lndo.site" "https://${name}-app.lndo.site"
#read -p "Press [Enter] key to move on to the next."

 SOURCECODE_UPLOADS=${src_prefix}_WP_UPLOADS.tar.gz
 SOURCECODE_PLUGINS=${src_prefix}_WP_PLUGINS.tar.gz
 SOURCECODE_THEMES=${src_prefix}_WP_THEMES.tar.gz
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
