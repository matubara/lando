#!/bin/bash


proj=test2


echo "Drupalデフォルト環境構築が完了しました"
echo "続けてDEV環境を設定します"
read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

#./add-drupal-devmode.sh $proj


echo "続けてCOMPOSERでモジュールをインストールします"
read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

./install-drupal-modules-via-composer.sh $proj


echo "続けてDRUSHでモジュールを有効化します"
read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

./activate-drupal-modules-via-drush.sh $proj
