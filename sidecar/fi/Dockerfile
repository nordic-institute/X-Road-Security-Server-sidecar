FROM niis/xroad-security-server-sidecar:latest

# Clone the conf files into the docker container
RUN  curl -L https://raw.githubusercontent.com/nordic-institute/X-Road/master/src/packages/src/xroad/default-configuration/override-securityserver-fi.ini -o /etc/xroad/conf.d/override-securityserver-fi.ini

