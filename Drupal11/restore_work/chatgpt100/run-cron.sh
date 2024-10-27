cd /home/kusanagi/prod_chatgpt/chatgpt100
echo `date`: `whoami`': cron kicked' >> cron.log
/opt/kusanagi/php/bin/php /home/kusanagi/prod_chatgpt/chatgpt100/vendor/drush/drush/drush --uri=chatdeoshiete.com --quiet cron
echo "Drush cron completed"
