#!/bin/bash
provision=prod_chatgpt
project=chatgpt100
cd /home/kusanagi/${provision}
export DRUSH_LAUNCHER_FALLBACK=/home/kusanagi/${provision}/vendor/drush/drush/drush
DESTDIR=BACKUP-CHATDEOSHIETE
if [ $# -eq 1 ];then
    TARGETDIR=$1
    SYSDATE=`date '+%Y%m%d_%H%M%S_'`
    DEST=$SYSDATE$1
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
/opt/kusanagi/php/bin/php /home/kusanagi/${provision}/${project}/vendor/drush/drush/drush sql:dump > ../../archives/${DEST}.sql
popd
echo "ファイルのバックアップを取得する(-vオプション無効)"
tar czf ../archives/${DEST}.tar.gz ./${TARGETDIR}/
echo "ファイルをConoHaWINGサーバーに転送する"
#./scp-stansfer-to-conohawing.sh bak.tar.gz ../../archives/${DEST}.sql
#./scp-stansfer-to-conohawing.sh bak.tar.gz ../archives/${DEST}.tar.gz

 scp -i /home/kusanagi/key/conoha-vps/vps-sinceretechnology.pem \
     -P 8022 \
     ../archives/${DEST}.sql\
     c4389980@www1041.conoha.ne.jp:/home/c4389980/$DESTDIR/${DEST}.sql
 scp -i /home/kusanagi/key/conoha-vps/vps-sinceretechnology.pem \
     -P 8022 \
     ../archives/${DEST}.tar.gz\
     c4389980@www1041.conoha.ne.jp:/home/c4389980/$DESTDIR/${DEST}.tar.gz


echo バックアップ完了しました
