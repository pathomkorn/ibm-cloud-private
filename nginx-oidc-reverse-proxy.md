# Setup NGINX Reverse Proxy to Solve OpenID Connect (OIDC) Redirection Issue
* Install NGINX
```bash
$ yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ yum install -y nginx
```
* Generate x.509 certificate
```bash
$ mkdir /etc/nginx/ssl
$ cd /etc/nginx/ssl
$ openssl req -x509 -newkey rsa:4096 -keyout icp.pem -out icp.crt -days 7300
$ openssl rsa < icp.pem  > icp.key
$ openssl dhparam -out dhparam.pem 2048
```
* Disable NGINX default server configuration by comment out ```server { }``` block in ```/etc/nginx/nginx.conf```
```bash
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
* Refer SSL Ciphers from https://testssl.sh/openssl-rfc.mapping.html
```bash
ssl_certificate /etc/nginx/ssl/icp.crt;
ssl_certificate_key /etc/nginx/ssl/icp.key;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;
ssl_dhparam /etc/nginx/ssl/dhparam.pem;
ssl_protocols TLSv1.2;
ssl_ciphers 'ECDHE-RSA-AES128-SHA:AES128-SHA:!DSS';
ssl_prefer_server_ciphers on;
add_header Strict-Transport-Security max-age=15768000;
ssl_stapling on;
ssl_stapling_verify on;

server {
    listen 8443 ssl;
    ssl on;
    error_page 497  https://$host:$server_port$request_uri;   # Redirect to HTTPS is requesting protocol is HTTP
    location / {
        proxy_pass ${ORIGINAL_ICP_MASTER_NODE}:8443/;
        sub_filter '${ORIGINAL_ICP_MASTER_NODE}:8443' '${NATED_ICP_MASTER_NODE}:8443';   # Replace logout OIDC URL to NATed IP address
        sub_filter_types *;
    }
}
```
* Start NGINX
```bash
$ systemctl enable nginx
$ systemctl start nginx
```
