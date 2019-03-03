# Connect Docker Toolbox to ICP Registry

```bash
echo "sudo mkdir /var/lib/boot2docker/certs && echo | openssl s_client -connect ${cluster_CA_domain}:8500 2> /dev/null | sudo openssl x509 -out /var/lib/boot2docker/certs/${cluster_CA_domain}.pem" | docker-machine ssh && docker-machine restart
```
