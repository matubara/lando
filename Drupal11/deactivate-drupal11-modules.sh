# Install drupal modules via composer
name=$1

 pushd ./${name}
 pwd

lando drush pm:uninstall ban -y
lando drush pm:uninstall layout_builder -y
lando drush pm:uninstall layout_discovery -y
lando drush pm:uninstall media -y
lando drush pm:uninstall media_library -y
lando drush pm:uninstall settings_tray -y
lando drush pm:uninstall syslog -y
lando drush pm:uninstall admin_toolbar -y
lando drush pm:uninstall admin_toolbar_tools -y
lando drush pm:uninstall admin_toolbar_search -y
lando drush pm:uninstall devel -y
lando drush pm:uninstall devel_generate -y
lando drush pm:uninstall field_group -y
lando drush pm:uninstall datetime_range -y
lando drush pm:uninstall telephone -y
lando drush pm:uninstall symfony_mailer -y
lando drush pm:uninstall mailsystem -y
lando drush pm:uninstall twig_tweak -y
lando drush pm:uninstall ultimate_cron -y
lando drush pm:uninstall queue_ui -y
lando drush pm:uninstall social_api -y
lando drush pm:uninstall social_auth -y
lando drush pm:uninstall social_auth_google -y
lando drush pm:uninstall basic_auth -y
lando drush pm:uninstall jsonapi -y
lando drush pm:uninstall rest -y
lando drush pm:uninstall serialization -y

