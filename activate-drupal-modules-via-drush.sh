# Activate drupal modules via drush
name=$1

 pushd ./${name}
 pwd

lando drush pm:install admin_toolbar
lando drush pm:install content_export_csv
lando drush pm:install csv_importer
lando drush pm:install examples
lando drush pm:install mailsystem
lando drush pm:install swiftmailer
lando drush pm:install devel

lando drush pm:install action
lando drush pm:install tracker
lando drush pm:install ban
lando drush pm:install layout_builder
lando drush pm:install layout_discovery
lando drush pm:install media
lando drush pm:install media_library
lando drush pm:install responsive_image
lando drush pm:install settings_tray
lando drush pm:install statistics
lando drush pm:install syslog
lando drush pm:install admin_toolbar
lando drush pm:install admin_toolbar_links_access_filter
lando drush pm:install admin_toolbar_search
lando drush pm:install datetime_range
lando drush pm:install telephone
lando drush pm:install config_translation
lando drush pm:install content_translation
lando drush pm:install locale
lando drush pm:install language
lando drush pm:install basic_auth
lando drush pm:install jsonapi
lando drush pm:install rest
lando drush pm:install serialization
lando drush pm:install leaflet
lando drush pm:install leaflet_markercluster
lando drush pm:install leaflet_views
lando drush pm:install multiselect
lando drush cr
popd
