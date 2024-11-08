#!/usr/bin/bash
######################################################
# パラメータを変数に取り込む 
source ./getparameters.sh
######################################################

if [ -d ./${drupalproj} ]; then
  echo "【警告】既にフォルダが存在します。";
  echo "処理を中断します";
  exit 1;
fi

######################################################
    echo "【確認】設定内容を確認してください"
    echo "現在のDrupal Project フォルダ名: ${drupalproj}"
    echo "バックアップファイル（転送元）のDrupal Project フォルダ名: ${drupalproj_old}"
    echo "Drupalバージョン: ${DRUPALSET}"
    read -p "よろしければ(y)、中断する場合は(N)を押してください (y/N): " yn
    case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
######################################################
#constファイルの読み込み
source ./const_lando_builddrupal.sh
######################################################

TIME1=$(cat /proc/uptime | awk '{print $1}')
echo time1: $TIME1

##### 計測したい処理ここから


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

# Drupal環境構築用スクリプトを実行します
bash ./mkdrupal11xdbg.sh ${drupalproj} ${drupalproj_old} ${DRUPALSET}


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

bash ./add-drupal11-devmode.sh ${drupalproj}


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

bash ./install-drupal11-modules-via-composer.sh ${drupalproj}


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

bash ./activate-drupal11-modules.sh ${drupalproj}


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
	cp ./restore_work ./${drupalproj} -rf
	cd ./${drupalproj}/restore_work 
	#アプリインストールスクリプトを実行する
	./lando_restore_drupal.sh ${drupalproj} ${drupalproj_old}
fi

lando info


##### 計測したい処理ここまで

TIME2=$(cat /proc/uptime | awk '{print $1}')
echo time2: $TIME2

DIFF=$(echo "$TIME2 - $TIME1" | bc)

echo "${GREEN}経過時間(s)：${DIFF}${RESET}"


echo "${YELLOW}すべての処理を完了しました。${RESET}" 
