# Install drupal modules via composer
name=$1

 pushd ./${name}
 pwd

lando drush pm:install ban -y
lando drush pm:install layout_builder -y
lando drush pm:install layout_builder -y
lando drush pm:install layout_discovery -y
lando drush pm:install media -y
lando drush pm:install media_library -y
lando drush pm:install settings_tray -y
lando drush pm:install syslog -y
lando drush pm:install admin_toolbar -y
lando drush pm:install admin_toolbar_tools -y
lando drush pm:install admin_toolbar_search -y
lando drush pm:install field_group -y
lando drush pm:install datetime_range -y
lando drush pm:install telephone -y
lando drush pm:install twig_tweak -y
lando drush pm:install group -y
lando drush pm:install gnode -y
lando drush pm:install group_support_revisions -y
lando drush pm:install content_moderation -y

#Development
lando drush pm:install devel -y
lando drush pm:install devel_generate -y
#Mail
lando drush pm:install symfony_mailer -y
lando drush pm:install mailsystem -y
#Cron
lando drush pm:install ultimate_cron -y
lando drush pm:install queue_ui -y
#SNS
lando drush pm:install social_api -y
lando drush pm:install social_auth -y
lando drush pm:install social_auth_google -y
#language
lando drush pm:install config_translation -y
lando drush pm:install content_translation -y
lando drush pm:install locale -y
lando drush pm:install language -y
#API
lando drush pm:install basic_auth -y
lando drush pm:install jsonapi -y
lando drush pm:install rest -y
lando drush pm:install serialization -y
#Theme
lando drush theme:enable bootstrap5
lando drush config:set system.theme default bootstrap5 -y
