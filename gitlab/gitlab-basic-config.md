# GitLab Basic Configuration
```bash
$ cat /etc/gitlab/gitlab.rb | grep -v "^#" | grep -v "^$"
external_url 'http://gitlab.default.svc.cluster.local'
gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main: # 'main' is the GitLab 'provider ID' of this LDAP server
    label: 'LDAP'
    host: '${AD_SERVER_IP}'
    port: 389
    uid: 'mail'
    bind_dn: 'cn=${DOMAIN_USER_USERNAME},cn=Users,dc=example,dc=com'
    password: '${DOMAIN_USER_PASSWORD}'
    encryption: 'plain' # "start_tls" or "simple_tls" or "plain"
    verify_certificates: true
    active_directory: true
    allow_username_or_email_login: false
    block_auto_created_users: false
    base: 'ou=${USER_OU},dc=example,dc=com'
    user_filter: '(objectClass=person)'
EOS
```
```bash
$ gitlab-ctl reconfigure
$ gitlab-ctl restart
```
