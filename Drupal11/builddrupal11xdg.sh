STEPMODE=false
####################################################
# kusanagiプロビジョニングとDrupalインストール実施 #
####################################################

# 表示用制御文字の設定
ESC=$(printf '\033') RESET="${ESC}[0m"

BOLD="${ESC}[1m"        FAINT="${ESC}[2m"       ITALIC="${ESC}[3m"
UNDERLINE="${ESC}[4m"   BLINK="${ESC}[5m"       FAST_BLINK="${ESC}[6m"
REVERSE="${ESC}[7m"     CONCEAL="${ESC}[8m"     STRIKE="${ESC}[9m"
GOTHIC="${ESC}[20m"     DOUBLE_UNDERLINE="${ESC}[21m" NORMAL="${ESC}[22m"
NO_ITALIC="${ESC}[23m"  NO_UNDERLINE="${ESC}[24m"     NO_BLINK="${ESC}[25m"
NO_REVERSE="${ESC}[27m" NO_CONCEAL="${ESC}[28m"       NO_STRIKE="${ESC}[29m"
BLACK="${ESC}[30m"      RED="${ESC}[31m"        GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"     BLUE="${ESC}[34m"       MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"       WHITE="${ESC}[37m"      DEFAULT="${ESC}[39m"
BG_BLACK="${ESC}[40m"   BG_RED="${ESC}[41m"     BG_GREEN="${ESC}[42m"
BG_YELLOW="${ESC}[43m"  BG_BLUE="${ESC}[44m"    BG_MAGENTA="${ESC}[45m"
BG_CYAN="${ESC}[46m"    BG_WHITE="${ESC}[47m"   BG_DEFAULT="${ESC}[49m"

CONFIRMMES="${RED}よろしければENTERキーで次に進みます。問題があればNを押して中断してください。${RESET}"

if [ $# -eq 0 ];then
    #プロンプトをechoを使って表示
    echo -n foldername=
    #入力を受付、その入力を「str」に代入
    read name
    echo "フォルダ名は ${name} でよろしいですか？(Yes[enter]/No)"
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac

elif [ $# -eq 1 ]; then
    name=$1
    echo "フォルダ名は ${name} でよろしいですか？(Yes[enter]/No)"
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac

else
    echo "引数が不正です"
    exit 1
fi

echo Drupal開発環境を構築します
if "${STEPMODE}"; then
echo ${CONFIRMMES};
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac
fi
bash ./mkdrupal11xdbg.sh ${name} drupal10

echo デバッグモードを有効にします
if "${STEPMODE}"; then
echo ${CONFIRMMES};
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac
fi

bash ./add-drupal11-devmode.sh ${name}

echo コントリビュートモジュールをインストールします
if "${STEPMODE}"; then
echo ${CONFIRMMES};
read  yesno
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac
fi

bash ./install-drupal11-modules-via-composer.sh ${name}

echo コントリビュートモジュールを有効化します
if "${STEPMODE}"; then
echo ${CONFIRMMES};
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac
fi

bash ./activate-drupal11-modules.sh ${name}


echo "アプリをインストールします"
if "${STEPMODE}"; then
echo ${CONFIRMMES};
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac
fi

cp ./restore_work ./${name} -rf
cd ./${name}/restore_work 
./lando_restore_drupal.sh ${name} 

echo "${YELLOW}すべての処理を完了しました。${RESET}" 
cd ${name}
lando info

echo "アプリをインストールしますか？"
if "${STEPMODE}"; then
echo ${CONFIRMMES};
case "${yesno}" in
  [nN] | NO | no |No)
    echo "clancel"
    exit ;;
  *)
    ;;
esac
fi
echo アプリを起動する
google-chrome https://${name}.lndo.site
