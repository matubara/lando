#ステップ実行モード
STEPMODE=false
#アプリインストール
APPINSTALL=true

################################################################
#DRUPALSET: mkdrupal11xdbg.shの第二引数(左記以外では使用されない)

if [ "${DRUPALSET}" = "drupal11" ]; then
#DRUPALSET=Drupal11の設定値（特定のバージョン11.0.5）
drupalver=:11.0.5
phpver=8.3
dbver=mysql:8.0

elif [ "${DRUPALSET}" = "drupal10+" ]; then
#RUPALSET=Drupal10の設定値（特定のバージョン10.3.6）
drupalver=:10.3.6
phpver=8.3
dbver=mysql:8.0

elif [ "${DRUPALSET}" = "drupal10" ]; then
#RUPALSET=Drupal10の設定値（特定のバージョン10.3.6）
drupalver=:10.3.6
phpver=8.1
dbver=mysql:5.7

fi
#################################################################

#LANDO設定
recipe=drupal10

#LOGINアカウント設定
adminuser=admin
adminpass=admin

#デバッグON/OFF
XDEBUGFLG=true

profile=lando
backupfile=20241029_041002_chatgpt100.tar.gz
backupdb=20241029_041002_chatgpt100.sql



####################################################
# kusanagiプロビジョニングとDrupalインストール実施 #
####################################################

# 表示用制御文字の設定
ESC=$(printf '\033') RESET="${ESC}[0m"

BOLD="${ESC}[1m"        FAINT="${ESC}[2m"       ITALIC="${ESC}[3m"
UNDERLINE="${ESC}[4m"   BLINK="${ESC}[5m"       FAST_BLINK="${ESC}[6m"
REVERSE="${ESC}[7m"     CONCEAL="${ESC}[8m"     STRIKE="${ESC}[9m"
GOTHIC="${ESC}[20m"     DOUBLE_UNDERLINE="${ESC}[21m" NORMAL="${ESC}[22m"
NO_ITALIC="${ESC}[23m"  NO_UNDERLINE="${ESC}[24m"     NO_BLINK="${ESC}[25m"
NO_REVERSE="${ESC}[27m" NO_CONCEAL="${ESC}[28m"       NO_STRIKE="${ESC}[29m"
BLACK="${ESC}[30m"      RED="${ESC}[31m"        GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"     BLUE="${ESC}[34m"       MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"       WHITE="${ESC}[37m"      DEFAULT="${ESC}[39m"
BG_BLACK="${ESC}[40m"   BG_RED="${ESC}[41m"     BG_GREEN="${ESC}[42m"
BG_YELLOW="${ESC}[43m"  BG_BLUE="${ESC}[44m"    BG_MAGENTA="${ESC}[45m"
BG_CYAN="${ESC}[46m"    BG_WHITE="${ESC}[47m"   BG_DEFAULT="${ESC}[49m"

CONFIRMMES="${RED}よろしければENTERキーを押してください。次に進みます。${RESET}"


