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
    echo "引数が不正です"
    exit 1
fi

