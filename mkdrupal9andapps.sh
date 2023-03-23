target=testdrupal
/bin/bash mkdrupal9xdbg.sh $target
/bin/bash add-drupal-devmode.sh $target
/bin/bash installdrupal-lando2.sh $target
