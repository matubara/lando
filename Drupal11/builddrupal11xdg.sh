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
    echo "フォルダ名は ${name} でよろしいですか？"
    read -p "ok? (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
else
    echo "引数が不正です"
    exit 1
fi

bash ./mkdrupal11xdbg.sh ${name}
echo "次のステップに進んでも大丈夫ですか?(Yes[Enter]/No)"
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac

bash ./add-drupal11-devmode.sh ${name}
echo "次のステップに進んでも大丈夫ですか?(Yes[Enter]/No)"
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac

bash ./install-drupal11-modules-via-composer.sh ${name}
echo "次のステップに進んでも大丈夫ですか?(Yes[Enter]/No)"
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac

bash ./activate-drupal11-modules.sh ${name}

lando info
    echo "すべての処理を完了しました"
