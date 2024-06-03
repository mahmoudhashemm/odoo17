server {
  listen 443 ssl;
  server_name 16.alredaa.co;
  proxy_read_timeout 720s;
  proxy_connect_timeout 720s;
  proxy_send_timeout 720s;

  # إعدادات SSL
  ssl_certificate /etc/letsencrypt/live/16.alredaa.co/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/16.alredaa.co/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

  # السجلات
  access_log /var/log/nginx/odoo.access.log;
  error_log /var/log/nginx/odoo.error.log;

  # إعادة توجيه طلبات websocket إلى منفذ gevent في odoo
  location /websocket {
    proxy_pass http://odoochat;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;  # requires nginx 1.19.8
  }

  # إعادة توجيه الطلبات إلى خادم odoo الخلفي
  location / {
    # إضافة رؤوس لنسق البروكسي الخاص بـ odoo
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_redirect off;
    proxy_pass http://odoo;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    proxy_cookie_flags session_id samesite=lax secure;  # requires nginx 1.19.8
  }

  # إعدادات gzip
  gzip_types text/css text/scss text/plain text/xml application/xml application/json application/javascript;
  gzip on;
}

# and install inginx and reinstall it





-----------------------
./odoo-bin -w a -s -c ../odoo.conf --stop-after-init

sudo systemctl daemon-reload
sudo systemctl enable odoo2
sudo systemctl start odoo2


chmod 644 /etc/odoo/odoo2.conf
chown odoo:odoo /etc/odoo/odoo2.conf



