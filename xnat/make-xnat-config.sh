#!/bin/sh

# generate xnat config
if [ ! -f $XNAT_HOME/config/xnat-conf.properties ]; then
  echo "  Generating $XNAT_HOME/config/xnat-conf.properties"
  cat > $XNAT_HOME/config/xnat-conf.properties << EOF
datasource.driver=$XNAT_DATASOURCE_DRIVER
datasource.url=$XNAT_DATASOURCE_URL
datasource.username=$XNAT_DATASOURCE_USERNAME
datasource.password=$XNAT_DATASOURCE_PASSWORD

hibernate.dialect=org.hibernate.dialect.PostgreSQL9Dialect
hibernate.hbm2ddl.auto=update
hibernate.show_sql=false
hibernate.cache.use_second_level_cache=true
hibernate.cache.use_query_cache=true

spring.http.multipart.max-file-size=1073741824
spring.http.multipart.max-request-size=1073741824
EOF
fi


if [ ! -z "$XNAT_EMAIL" ]; then
  echo "  Generating $XNAT_HOME/config/prefs-init.ini"
  cat > $XNAT_HOME/config/prefs-init.ini << EOF
[siteConfig]
adminEmail=$XNAT_EMAIL
EOF
fi

if [ "$XNAT_SMTP_ENABLED" = true ]; then
  echo "  Generating $XNAT_HOME/config/prefs-init.ini"
  cat >> $XNAT_HOME/config/prefs-init.ini << EOF
[notifications]
smtpEnabled=true
smtpHostname=$XNAT_SMTP_HOSTNAME
smtpPort=$XNAT_SMTP_PORT
smtpUsername=$XNAT_SMTP_USERNAME
smtpPassword=$XNAT_SMTP_PASSWORD
smtpAuth=$XNAT_SMTP_AUTH
EOF
fi

if [ "$XNAT_LDAP_AMC_ENABLED" = true ]; then
  # add ldap config AMC
  echo "  Generating $XNAT_HOME/config/auth/${XNAT_LDAP_AMC_PROVIDER_ID}-provider.properties"
  mkdir -p $XNAT_HOME/config/auth
  cat >> $XNAT_HOME/config/auth/${XNAT_LDAP_AMC_PROVIDER_ID}-provider.properties << EOF
name=$XNAT_LDAP_AMC_HOSTNAME
provider.id=$XNAT_LDAP_AMC_PROVIDER_ID
auth.method=ldap
visible=$XNAT_LDAP_AMC_VISIBLE
auto.enabled=$XNAT_LDAP_AMC_AUTO_ENABLED
auto.verified=$XNAT_LDAP_AMC_AUTO_VERIFIED
address=$XNAT_LDAP_AMC_ADDRESS
userdn=$XNAT_LDAP_AMC_USERDN
password=$XNAT_LDAP_AMC_PASSWORD
search.base=$XNAT_LDAP_AMC_SEARCH_BASE
search.filter=$XNAT_LDAP_AMC_SEARCH_FILTER
EOF
fi

mkdir -p /usr/local/share/xnat
find $XNAT_HOME/config -mindepth 1 -maxdepth 1 -type f -exec cp {} /usr/local/share/xnat \;


