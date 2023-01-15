
echo count=$#
if [ $# -eq 1 ];then
    TARGETDIR=$1
    DEST=$1
elif [ $# -eq 2 ];then
    TARGETDIR=$1
    DEST=$2
else
    echo "引数を確認してください"
    echo "【第1引数】(必須) ターゲットディレクトリ名を指定してください"
    echo "【第2引数】（オプション）出力ファイル名を指定してください"
    exit 1
fi
pushd ${TARGETDIR}
echo データベースのバックアップを取得する
lando drush sql:dump > ../../archives/${DEST}.sql
echo "ファイルのバックアップを取得する(-vオプション無効)"
sudo tar czf ../../archives/${DEST}.tar.gz ./web/
echo バックアップ完了しました
popd
