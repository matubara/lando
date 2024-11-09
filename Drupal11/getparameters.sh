###############################################################
#下記変数の入力と、定数の読み込み
#name, DRUPALSET
#定数読み込みの順序に注意すること
# ※ DRUPALSETの値により読み込まれる定数の内容が変わる
###############################################################

if [ $# -eq 0 ];then
    #プロンプトをechoを使って表示
    echo -n "現在の Drupal project名="
    #入力を受付、その入力を「drupalproj」に代入
    read drupalproj
    #プロンプトをechoを使って表示
    echo -n "転送元（バックアップファイル内）のDrupal project名="
    #入力を受付、その入力を「drupalproj_old」に代入
    read drupalproj_old
    echo "Drupal project名は次の通りです"
    echo "現在のDrupal project名： ${drupalproj} "
    echo "転送元（バックアップファイル内）のDrupal project名： ${drupalproj_old} "
    read -p ${CONFIRMMES}

    #デフォルト値設定
    DRUPALSET=drupal10
elif [ $# -eq 3 ] && [ $3 = "drupal10+" ]; then
    drupalproj=$1
    drupalproj_old=$2
    DRUPALSET=$3
elif [ $# -eq 3 ] && [ $3 = "drupal10" ]; then
    drupalproj=$1
    drupalproj_old=$2
    DRUPALSET=$3
elif [ $# -eq 3 ] && [ $3 = "drupal11" ]; then
    drupalproj=$1
    drupalproj_old=$2
    DRUPALSET=$3
else
    echo "【警告】引数が不正です"
    echo "第一引数：現在のDrupalProject名"
    echo "第二引数：バックアップファイル（転送元）のDrupalProject名"
    echo "第三引数：Drupal設定パターン設定用のID（詳細は以下参照）"
    echo "【Drupal設定パターン設定ID】"
    echo "drupal10 => php8.1, mySQL5.7, Drupal10.3.6"
    echo "drupal10+ => php8.1, mySQL5.7, Drupal10.3.6"
    echo "drupal11 => php8.3, mySQL8.0, Drupal11.0.5"
    echo "※ 第三引数は上記のいずれかを設定してください"
    exit 1
fi

