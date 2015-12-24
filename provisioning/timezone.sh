  #!/usr/bin/env bash

# $1 is timezone

echo "Setting Timezone to $3"
sudo ln -sf /usr/share/zoneinfo/$3 /etc/localtime



echo "Setting Locale to en_US.UTF-8"
sudo apt-get install -qq language-pack-en
sudo locale-gen en_US
sudo update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

