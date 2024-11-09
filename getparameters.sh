###############################################################
#下記変数の入力と、定数の読み込み
#name, DRUPALSET
#定数読み込みの順序に注意すること
# ※ DRUPALSETの値により読み込まれる定数の内容が変わる
###############################################################

#readonly APPINSTALL=false
DRUPALSET=UNDEFINED
if [ $# -eq 2 ]; then
    drupalproj=$1
    DRUPALSET=$2
    #アプリインストールしない
    readonly APPINSTALL=false
elif [ $# -eq 4 ]; then
    drupalproj=$1
    DRUPALSET=$2
    drupalproj_old=$3
    backupname=$4
    #アプリインストールする
    readonly APPINSTALL=true
else
    echo "【警告】引数が不正です"
    echo "第一引数：現在のDrupalProject名"
    echo "第二引数：Drupal設定パターン設定用のID（詳細は以下参照）"
    echo "※ オプショナル 第三引数：バックアップファイル（転送元）のDrupalProject名"
    echo "※ オプショナル 第四引数：バックアップファイル名"
    echo "【Drupal設定パターン設定ID】"
    echo "drupal10 => php8.1, mySQL5.7, Drupal10.3.6"
    echo "drupal10+ => php8.3, mySQL8.0, Drupal10.3.6"
    echo "drupal11 => php8.3, mySQL8.0, Drupal11.0.5"
    echo "※ 第三引数は上記のいずれかを設定してください"
    exit 1
fi

if [ "${DRUPALSET}" = "drupal10" ]; then
    echo "【pass】Drupal設定パターン = ${DRUPALSET}"
    echo "drupal10 => php8.1, mySQL5.7, Drupal10.3.6"
elif [ "${DRUPALSET}" = "drupal10+" ]; then
    echo "【pass】Drupal設定パターン = ${DRUPALSET}"
    echo "drupal10+ => php8.3, mySQL8.0, Drupal10.3.6"
elif [ "${DRUPALSET}" = "drupal11" ]; then
    echo "【pass】Drupal設定パターン = ${DRUPALSET}"
    echo "drupal11 => php8.3, mySQL8.0, Drupal11.0.5"
else
    echo "【警告】入力されたDrupal設定パターンが不正です"
    echo "【pass】Drupal設定パターン ≠= ${DRUPALSET}"
    echo "中断します"
    exit 1    
fi

echo "【確認】設定情報は次の通りです"
echo "現在のDrupal project名： ${drupalproj} "
echo "Drupal pattern id： ${DRUPALSET} "
if "${APPINSTALL}"; then
    echo "アプリインストール：する"
    echo "転送元（バックアップファイル内）のDrupal project名： ${drupalproj_old} "
    echo "リストア対象ファイル：${backupname}.tar.gz"
    echo "リストア対象データベース：${backupname}.sql"
else
    echo "アプリインストール：しない"
fi

