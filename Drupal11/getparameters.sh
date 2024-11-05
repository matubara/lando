###############################################################
#下記変数の入力と、定数の読み込み
#name, DRUPALSET
#定数読み込みの順序に注意すること
# ※ DRUPALSETの値により読み込まれる定数の内容が変わる
###############################################################

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
elif [ $# -eq 2 ] && [ $2 = "drupal10+" ]; then
    name=$1
    DRUPALSET=$2
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

