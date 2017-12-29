# Setup NGINX Reverse Proxy to Solve OpenID Connect (OIDC) Redirection Issue
* Install NGINX
```bash
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# yum install nginx
```
* Generate x.509 certificate
```bash
# mkdir /etc/nginx/ssl
# cd /etc/nginx/ssl
# openssl req -x509 -newkey rsa:4096 -keyout icp.pem -out icp.crt -days 7300
# openssl rsa < icp.pem  > icp.key
```
* Disable NGINX default server configuration by comment out all ```server { }``` syntax
```bash
# vi /etc/nginx/nginx.conf
#    server {
#        listen       80 default_server;
#        listen       [::]:80 default_server;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        location / {
#        }
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }
```
* Enable NGINX reverse proxy configuration in ```/etc/nginx/conf.d/icp-rproxy.conf```
```bash
ssl_certificate /etc/nginx/ssl/icp.crt;
ssl_certificate_key /etc/nginx/ssl/icp.key;
ssl_session_timeout 5m;
ssl_prefer_server_ciphers on;
ssl_protocols TLSv1.2;
ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;

server {
    listen 8443 ssl;
    ssl on;
    location / {
        proxy_pass ${ORIGINAL_ICP_MASTER_NODE}:8443/;
        sub_filter '${ORIGINAL_ICP_MASTER_NODE}:8443' '${NATED_ICP_MASTER_NODE}:8443';
        sub_filter_types *;
    }
}
```
* Start NGINX
```bash
# systemctl enable nginx
# systemctl start nginx
```
