
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
echo データベースを復元する
    lando drush sql-cli < ../../archives/${DEST}.sql
popd

if [ ! -d ./work ]; then
    echo '6295' | sudo mkdir ./work
fi
pushd ./work
echo 圧縮ファイルをワークフォルダにコピーする
    echo '6295' | sudo cp ../../archives/${DEST}.tar.gz ./
echo ファイルを解凍する
    echo '6295' | sudo tar zxf ./${DEST}.tar.gz ./
echo webフォルダを上書きコピーする
    echo '6295' | sudo cp -rp ./${TARGETDIR} ../
popd
