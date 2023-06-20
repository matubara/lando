#!/bin/bash

proj=test1

echo "Drupalデフォルト環境構築が完了しました"
echo "続けてDEV環境を設定します"
read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

./add-drupal-devmode.sh $proj