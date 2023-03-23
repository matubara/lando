
#!/bin/bash

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
if [ ! -d ./${TARGETDIR} ]; then
    echo "対象のディレクトリが存在しません"
    exit 1
fi

pushd ${TARGETDIR}
echo データベースのバックアップを取得する
lando drush sql:dump > ../../archives/${DEST}.sql
popd
echo "ファイルのバックアップを取得する(-vオプション無効)"
echo '6295' | sudo tar czf ../archives/${DEST}.tar.gz ./${TARGETDIR}/
echo バックアップ完了しました
