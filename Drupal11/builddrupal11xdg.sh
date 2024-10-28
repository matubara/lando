#!/usr/bin/bash
######################################################
# DRUPALSET: mkdrupal11xdbg.shの第二引数に引き渡す定数

if [ $# -eq 0 ];then
    #プロンプトをechoを使って表示
    echo -n foldername=
    read name
    #デフォルト値設定
    DRUPALSET=drupal10
elif [ $# -eq 1 ]; then
    name=$1
    #デフォルト値設定
    DRUPALSET=drupal10
elif [ $# -eq 2 ] && [ $2 = "drupal10" ]; then
    name=$1
    DRUPALSET=$2
elif [ $# -eq 2 ] && [ $2 = "drupal11" ]; then
    name=$1
    DRUPALSET=$2
else
    echo "引数が不正です"
    exit 1
fi
######################################################
    echo "【確認】設定内容を確認してください"
    echo "フォルダ名: ${name}"
    echo "Drupalバージョン: ${DRUPALSET}" 
    read -p "よろしければ(y)、中断する場合は(N)を押してください (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
######################################################
#constファイルの読み込み
source ./const_lando_builddrupal.sh
######################################################


echo "${YELLOW}Drupal開発環境を構築します${RESET}"
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

bash ./mkdrupal11xdbg.sh ${name} ${DRUPALSET}


echo "${YELLOW}デバッグモードを有効にします${RESET}"
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


echo "${YELLOW}コントリビュートモジュールをインストールします${RESET}"
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


echo "${YELLOW}コントリビュートモジュールを有効化します${RESET}"
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


if "${APPINSTALL}"; then
echo "${YELLOW}アプリをインストールします${RESET}"
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
	#アプリ実行用フォルダをDrupalプロジェクトフォルダに作成する
	cp ./restore_work ./${name} -rf
	cd ./${name}/restore_work 
	#アプリインストールスクリプトを実行する
	./lando_restore_drupal.sh ${name} 
fi

lando info

echo "${YELLOW}すべての処理を完了しました。${RESET}" 
