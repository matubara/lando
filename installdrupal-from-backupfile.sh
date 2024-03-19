# wp-config.phpのTABLE PREFIXを変更する
# .htaccessファイルをドキュメントルートに設置する
if [ $# -eq 0 ];then
    echo "引数が不正です"
    echo "第一引数：フォルダ名（LANDO用）"
    echo "第二引数：archivesフォルダのバックアップファイル名（拡張子は除く）"
    echo "第三引数：drupalプロジェクトファイル名（展開後のフォルダ名）"
    exit 1

    #プロンプトをechoを使って表示
    echo -n foldername=
    #入力を受付、その入力を「str」に代入
    read name
    echo "フォルダ名は ${name} でよろしいですか？"
    read -p "ok? (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
elif [ $# -eq 3 ]; then
    name=$1
    backupfile=$2  #ex 20240319_230925_studypocketonline100
    projectname=$3 #ex studypocketonline100
else
    echo "引数が不正です"
    echo "第一引数：フォルダ名（LANDO用）"
    echo "第二引数：archivesフォルダのバックアップファイル名（拡張子は除く）"
    echo "第三引数：drupalプロジェクトファイル名（展開後のフォルダ名）"
    exit 1
fi



 pushd ./${name}
 pwd

echo バックアップファイルをプロジェクトルートに展開します。よろしいですか？
read -p "Press [Enter] key to move on to the next."
echo "copy source code from archive folder"
cp ../../archives/${backupfile}.sql ./
cp ../../archives/${backupfile}.tar.gz ./
tar zxf ${backupfile}.tar.gz 

echo DRUPALのファイルをバックアップから取得したファイルで置き替えます。よろしいですか？
read -p "Press [Enter] key to move on to the next."
echo 既存のvendorおよびwebフォルダを退避する
mv ./vendor ./vendor-org
mv ./web ./web-org
cp ./${projectname}/composer.* ./ -f

echo バックアップファイルのvendorおよびwebフォルダを展開する
mv ./${projectname}/vendor ./
mv ./${projectname}/web ./
sudo chmod 777 ./web -R
sudo cp ./web-org/sites/default/settings.php ./web/sites/default/

echo "データベースをインポートします。よろしいですか？"
read -p "Press [Enter] key to move on to the next."
lando db-import ./${backupfile}.sql

echo デバッグ環境を設定する
sudo cp -f ./.lando_conf/drupal9/settings.local.php ./web/sites/default/
sudo cp -f ./.lando_conf/drupal9/development.services.yml ./web/sites/

sudo echo "" >> ./web/sites/default/settings.php
sudo echo "if (file_exists(\$app_root . '/' . \$site_path . '/settings.local.php')) {" >> ./web/sites/default/settings.php
sudo echo "  include \$app_root . '/' . \$site_path . '/settings.local.php';" >> ./web/sites/default/settings.php
sudo echo "}" >> ./web/sites/default/settings.php

echo キャッシュをクリアする
lando drush cr
lando info
popd
echo リストアを完了しました


