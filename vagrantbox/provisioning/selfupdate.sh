#!/usr/bin/env bash
echo ">>> Installing 2/13"
echo ">>> Installing Base Packages + Self update"

# Update
sudo apt-get update
# Install base packages
# -qq implies -y --force-yes
sudo apt-get install -qq curl unzip git-core ack-grep software-properties-common build-essential cachefilesd

echo ">>> Installing *.xip.io self-signed SSL"

SSL_DIR="/etc/ssl/xip.io"
DOMAIN="*.xip.io"
PASSPHRASE="chiragchamoli"

SUBJ="
C=IN
ST=Telengana
O=Sourceeasy
localityName=Banjara Hills
commonName=$DOMAIN
organizationalUnitName=
emailAddress=chirag@sourceeasy.com
"

sudo mkdir -p "$SSL_DIR"
sudo openssl genrsa -out "$SSL_DIR/xip.io.key" 1024
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/xip.io.key" -out "$SSL_DIR/xip.io.csr" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "$SSL_DIR/xip.io.csr" -signkey "$SSL_DIR/xip.io.key" -out "$SSL_DIR/xip.io.crt"



# Disable case sensitivity
shopt -s nocasematch

if [[ ! -z $2 && ! $2 =~ false && $2 =~ ^[0-9]*$ ]]; then

    echo ">>> Setting up Swap ($2 MB)"

    # Create the Swap file
    fallocate -l $2M /swapfile

    # Set the correct Swap permissions
    chmod 600 /swapfile

    # Setup Swap space
    mkswap /swapfile

    # Enable Swap space
    swapon /swapfile

    # Make the Swap file permanent
    echo "/swapfile   none    swap    sw    0   0" | tee -a /etc/fstab

    # Add some swap settings:
    # vm.swappiness=10: Means that there wont be a Swap file until memory hits 90% useage
    # vm.vfs_cache_pressure=50: read http://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that
    printf "vm.swappiness=10\nvm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf && sysctl -p

fi

# Enable case sensitivity
shopt -u nocasematch

# Enable cachefilesd
echo "RUN=yes" > /etc/default/cachefilesd

echo ">>> Finished installing 2/13"