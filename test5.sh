#!/bin/bash

# Function to display colorful billboard message
display_billboard() {
    printf "\e[91m\e[1m==================================================\e[0m\n"
    printf "\e[93m\e[1m%s\e[0m\n" "$1"
    printf "\e[91m\e[1m==================================================\e[0m\n"
}

# Function to prompt user for Odoo version
select_odoo_version() {
    echo "Please select the Odoo version:"
    echo "1) Odoo 14.0"
    echo "2) Odoo 15.0"
    echo "3) Odoo 16.0"
    echo "4) Odoo 17.0"
    read -rp "Enter your choice (1-4): " choice

    case $choice in
        1) OE_BRANCH="14.0";;
        2) OE_BRANCH="15.0";;
        3) OE_BRANCH="16.0";;
        4) OE_BRANCH="17.0";;
        *) echo "Invalid choice. Please enter a number between 1 and 4."; exit 1;;
    esac
}

# Display billboard message
billboard_message="Welcome to the Odoo Production Server Setup Script!"
display_billboard "$billboard_message"

# Prompt user for Odoo version
select_odoo_version

# Fixed parameters
OE_USER="odoo"

WEBSITE_NAME="16.alredaa.co"
OE_PORT="8069"
LONGPOLLING_PORT="8071"



# Add group
groupadd "$OE_USER"
# Add user
useradd --create-home -d /home/"$OE_USER" --shell /bin/bash -g "$OE_USER" "$OE_USER"
# Add user to sudoers
usermod -aG sudo "$OE_USER"

# The default port where this Odoo instance will run under (provided you use the command -c in the terminal)
# Set to true if you want to install it, false if you don't need it or have it already installed.
INSTALL_WKHTMLTOPDF="True"

# Set this to True if you want to install Odoo 9 10 11 12 13 14Enterprise! (you can use enterprise normally too)
IS_ENTERPRISE="True"

# WKHTMLTOPDF download links
WKHTMLTOX_X64="https://github.com/odoo/wkhtmltopdf/releases/download/nightly/odoo-wkhtmltopdf-ubuntu-jammy-x86_64-0.13.0-nightly.deb"
WKHTMLTOX_X32="https://github.com/odoo/wkhtmltopdf/releases/download/nightly/odoo-wkhtmltopdf-ubuntu-jammy-x86_64-0.13.0-nightly.deb"

# Update Server
echo -e "\n---- Update Server ----"
sudo apt-get update
sudo apt-get upgrade -y
apt install -y zip gdebi net-tools
echo "----------------------------localization-------------------------------"

#export LC_ALL="en_US.UTF-8"
#export LC_CTYPE="en_US.UTF-8"
#sudo dpkg-reconfigure locales

# Install PostgreSQL Server
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt -y install postgresql

echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
sudo su - postgres -c "createuser -s $OE_USER" 2> /dev/null || true

# Install Dependencies
echo -e "\n---- Install tool packages ----"
sudo apt install -y git python3-pip build-essential wget python3-dev python3-venv python3-wheel libfreetype6-dev libxml2-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libjpeg-dev zlib1g-dev libpq-dev libxslt1-dev libldap2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev
echo -e "\n---- Install python libraries ----"
sudo pip install gdata psycogreen
sudo -H pip install suds

echo -e "\n--- Install other required packages"
sudo apt-get install node-clean-css -y
sudo apt-get install node-less -y
sudo apt-get install python-gevent -y
sudo apt-get install libcairo2-dev python3-cairo -y
pip3 install rlPyCairo
apt-get install libwww-perl -y

# Install Wkhtmltopdf if needed
if [ $INSTALL_WKHTMLTOPDF = "True" ]; then
    echo -e "\n---- Install wkhtml and place shortcuts on correct place for ODOO 15.0 ----"
    if [ "`getconf LONG_BIT`" == "64" ];then
        _url=$WKHTMLTOX_X64
    else
        _url=$WKHTMLTOX_X32
    fi
    sudo wget $_url
    sudo gdebi --n `basename $_url`
else
    echo "Wkhtmltopdf isn't installed due to the choice of the user!"
fi

# Odoo Enterprise install
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y

echo -e "\n---- Installing Enterprise specific libraries ----"
sudo npm install -g less
sudo npm install -g less-plugin-clean-css
sudo npm install -g rtlcss

echo -e "\n---- everything is ready ----"

sudo ln -s /usr/bin/nodejs /usr/bin/node

sudo apt-get install -y python3-dev
sudo easy_install greenlet
sudo easy_install gevent
sudo apt-get install -y python3-pip python3-wheel python3-setuptools
sudo -H pip3 install --upgrade pip
sudo apt install -y python3-asn1crypto
sudo apt install -y python3-babel python3-bs4 python3-cffi-backend python3-cryptography python3-dateutil python3-docutils python3-feedparser python3-funcsigs python3-gevent python3-greenlet python3-html2text python3-html5lib python3-jinja2 python3-lxml python3-mako python3-markupsafe python3-mock python3-ofxparse python3-openssl python3-passlib python3-pbr python3-pil python3-psutil python3-psycopg2 python3-pydot python3-pygments python3-pyparsing python3-pypdf2 python3-renderpm python3-reportlab python3-reportlab-accel python3-roman python3-serial python3-stdnum python3-suds python3-tz python3-usb python3-werkzeug python3-xlsxwriter python3-yaml
pip3 install -r https://raw.githubusercontent.com/odoo/odoo/"$OE_BRANCH"/requirements.txt --user
pip3 install phonenumbers --user

mkdir /$OE_USER
mkdir /etc/$OE_USER
mkdir /var/log/$OE_USER
touch /etc/$OE_USER/$OE_USER.conf
touch /var/log/$OE_USER/odoo-server.log
chown $OE_USER:$OE_USER /var/log/$OE_USER/$OE_USER-server.log
chown $OE_USER:$OE_USER /etc/$OE_USER/$OE_USER.conf
cd /$OE_USER

sudo git clone --depth 1 --branch "$OE_BRANCH" https://www.github.com/odoo/odoo
cd /

chown -R $OE_USER:$OE_USER /$OE_USER

cd /root

# Adding Odoo as a deamon (Systemd)
echo -e "\n========== Create Odoo systemd file ==============="
cat <<EOF > /etc/systemd/system/$OE_USER.service
[Unit]
Description=Odoo Open Source ERP and CRM
After=network.target

[Service]
Type=simple
User=$OE_USER
Group=$OE_USER
ExecStart=/$OE_USER/$OE_USER/odoo-bin --config /etc/$OE_USER/${OE_USER}.conf --logfile /var/log/${OE_USER}/${OE_USER}.log
KillMode=mixed

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 755 /etc/systemd/system/$OE_USER.service
sudo chown root: /etc/systemd/system/$OE_USER.service

sudo systemctl daemon-reload
sudo systemctl enable $OE_USER
sudo systemctl start $OE_USER
echo "nginx:"
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx
sudo apt update
sudo apt install nginx
sudo systemctl enable nginx
  cat <<EOF > /etc/nginx/conf.d/${OE_USER}.conf
# odoo server
upstream ${OE_USER} {
  server 127.0.0.1:${OE_PORT};
}
upstream ${OE_USER}chat {
  server 127.0.0.1:${LONGPOLLING_PORT};
}

map \$http_upgrade \$connection_upgrade {
  default upgrade;
  ''      close;
}

# http -> https
server {
  listen 80;
  server_name ${WEBSITE_NAME};
  rewrite ^(.*) https://\$host\$1 permanent;

  server_name ${WEBSITE_NAME};
  proxy_read_timeout 720s;
  proxy_connect_timeout 720s;
  proxy_send_timeout 720s;



  # log
  access_log /var/log/nginx/odoo.access.log;
  error_log /var/log/nginx/odoo.error.log;

  # Redirect websocket requests to odoo gevent port
  location /websocket {
    proxy_pass http://${OE_USER}chat;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;
    proxy_set_header X-Forwarded-Host \$http_host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Real-IP \$remote_addr;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;  # requires nginx 1.19.8
  }

  # Redirect requests to odoo backend server
  location / {
    proxy_set_header X-Forwarded-Host \$http_host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_redirect off;
    proxy_pass http://${OE_USER};

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;  # requires nginx 1.19.8
  }

  # common gzip
  gzip_types text/css text/scss text/plain text/xml application/xml application/json application/javascript;
  gzip on;
}
EOF
sudo systemctl reload nginx




apt-get install -y perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python

apt-get install apt-transport-https -y
apt-get update
#!/bin/bash

#!/bin/bash

# تشغيل الأوامر كمستخدم odoo
su - "$OE_USER" -c "
    # تثبيت مكتبة decorator
    pip3 install --user decorator

    # الانتقال إلى دليل odoo
    cd /"$OE_USER"/odoo

    # تثبيت المتطلبات
    pip3 install --user -r requirements.txt
"


echo "-----------------------------------------------------------"
echo "Done! The Odoo production platform is ready:"
echo "Restart your computer and start developing. Have fun! ;)"
echo "-----------------------------------------------------------"
