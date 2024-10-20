# wp-config.phpのTABLE PREFIXを変更する
# .htaccessファイルをドキュメントルートに設置する
name=$1

 pushd ./${name}
 pwd

echo `ls ../lando_conf/drupal9/settings.local.php`

sudo chmod 777 ./web/ -R
sudo chmod 777 ./vendor/ -R

#デバッグ環境の設定
sudo cp -f  ./web/sites/default/settings.php ./web/sites/default/settings.php.bak
#sudo cp -f ../lando_conf/drupal9/settings.local.php ./web/sites/default/
#sudo cp -f ../lando_conf/drupal9/development.services.yml ./web/sites/
sudo cp -f ./web/sites/example.settings.local.php ./web/sites/default/settings.local.php

sudo chmod 777 ./web/sites/default/settings.php

sudo echo "" >> ./web/sites/default/settings.php
sudo echo "if (file_exists(\$app_root . '/' . \$site_path . '/settings.local.php')) {" >> ./web/sites/default/settings.php
sudo echo "  include \$app_root . '/' . \$site_path . '/settings.local.php';" >> ./web/sites/default/settings.php
sudo echo "}" >> ./web/sites/default/settings.php

popd
