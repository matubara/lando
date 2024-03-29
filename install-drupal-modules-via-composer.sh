# Install drupal modules via composer
name=$1

 pushd ./${name}
 pwd

lando composer require 'drupal/admin_toolbar:^3.3'
lando composer require 'drupal/content_export_csv:^4.5'
lando composer require 'drupal/csv_importer:^1.16'
lando composer require 'drupal/examples:^4.0'
lando composer require 'drupal/mailsystem:^4.4'
lando composer require 'drupal/swiftmailer:^2.4'
lando composer require 'drupal/devel:^5.1'
lando composer require 'drupal/leaflet:^10.0'
lando composer require 'drupal/multiselect:^2.0@beta'

popd
