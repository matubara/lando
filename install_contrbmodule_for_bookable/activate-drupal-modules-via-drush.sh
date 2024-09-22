# Activate drupal modules via drush
name=$1

 pushd ./${name}
 pwd

lando drush pm:install admin_toolbar -y
lando drush pm:install content_export_csv -y
lando drush pm:install csv_importer -y
lando drush pm:install examples -y
lando drush pm:install mailsystem -y
lando drush pm:install symfony_mailer -y
lando drush pm:install devel -y
lando drush pm:install bookable_calendar -y
lando drush pm:install calendar_view -y

lando drush pm:install action -y
lando drush pm:install tracker -y
lando drush pm:install ban -y
lando drush pm:install layout_builder -y
lando drush pm:install layout_discovery -y
lando drush pm:install media -y
lando drush pm:install media_library -y
lando drush pm:install responsive_image -y
lando drush pm:install settings_tray -y
lando drush pm:install statistics -y
lando drush pm:install syslog -y
lando drush pm:install admin_toolbar -y
lando drush pm:install admin_toolbar_links_access_filter -y
lando drush pm:install admin_toolbar_search -y
lando drush pm:install datetime_range -y
lando drush pm:install telephone -y
lando drush pm:install config_translation -y
lando drush pm:install content_translation -y
lando drush pm:install locale -y
lando drush pm:install language -y
lando drush pm:install basic_auth -y
lando drush pm:install jsonapi -y
lando drush pm:install rest -y
lando drush pm:install serialization -y
#lando drush pm:install multiselect -y
lando drush cr

popd
