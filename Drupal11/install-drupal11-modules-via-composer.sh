# Install drupal modules via composer
name=$1

 pushd ./${name}
 pwd

lando composer require 'drupal/admin_toolbar:^3.5'
#lando composer require 'drupal/examples:^4.0'
lando composer require 'drupal/mailsystem:^4.5'
lando composer require 'drupal/email_validator:^2.4'
lando composer require 'drupal/symfony_mailer:^1.5'
lando composer require 'drupal/devel:^5.2'
lando composer require 'drupal/social_api:^4.0'
lando composer require 'drupal/social_auth:^4.1'
lando composer require 'drupal/social_auth_google:^4.0'
lando composer require 'drupal/twig_tweak:^3.4'
lando composer require 'drupal/ultimate_cron:^2.0@alpha'
lando composer require 'drupal/group:^3.3'

#lando composer require 'drupal/multiselect:^2.0@beta'

lando composer require 'drupal/field_group:^3.6'
lando composer require 'drupal/queue_ui:^3.2'
lando composer require openai-php/client

lando composer require 'drupal/bootstrap5:^4.0'
popd
