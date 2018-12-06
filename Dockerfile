FROM debian:stretch-slim

MAINTAINER Dirk Winkel <it@polarwinkel.de>

# Install dependencies
RUN apt-get update && apt-get install -y \
      proftpd \
      proftpd-mod-ldap \
      nano

RUN sed -i 's/^ServerName.*$/ServerName ftp/' /etc/proftpd/proftpd.conf && \
        sed -i 's/^# AuthOrder.*$/AuthOrder mod_ldap.c/' /etc/proftpd/proftpd.conf && \
        sed -i '/^AuthOrder.*$/a LoadModule mod_ldap.c' /etc/proftpd/proftpd.conf && \
        sed -i 's!^#Include /etc/proftpd/ldap.conf$!Include /etc/proftpd/ldap.conf!' /etc/proftpd/proftpd.conf && \
        sed -i 's/^#LDAPServer.*$/LDAPServer ldap/' /etc/proftpd/ldap.conf && \
        sed -i 's/^#LDAPAuthBinds.*$/LDAPAuthBinds off/' /etc/proftpd/ldap.conf && \
        sed -i 's/^#LDAPUsers.*$/LDAPUsers "ou=users,dc=ldap,dc=philleconnect" "(uid=%u)"/' /etc/proftpd/ldap.conf && \
        sed -i 's/^#LDAPSearchScope.*$/LDAPSearchScope subtree/' /etc/proftpd/ldap.conf
        

EXPOSE 21

CMD	["proftpd", "--nodaemon"]
