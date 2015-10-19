FROM nginx:1.7

#Install Curl
RUN apt-get update -qq && apt-get -y install curl

#Link to Consul Template Binary
ENV CT_URL http://bit.ly/15uhv24

#Install Consul Template
RUN curl -L $CT_URL | \
tar -C /usr/local/bin --strip-components 1 -zxf -

#Setup Consul Template Files
RUN mkdir /etc/consul-templates

#Setup Nginx File
ENV CT_FILE ./assets/templates/nginx.conf.ctmpl
ENV CT_FILE_PATH /etc/consul-templates/nginx.conf
ENV NX_FILE /etc/nginx/conf.d/app.conf

#Default Variables
ENV CONSUL consul:8500
ENV SERVICE consul-8500

# Command will
# 1. Write Consul Template File
# 2. Start Nginx
# 3. Start Consul Template

ADD ${CT_FILE} ${CT_FILE_PATH}

CMD \
    /usr/sbin/nginx -c /etc/nginx/nginx.conf \
    & CONSUL_TEMPLATE_LOG=debug consul-template \
        -consul=$CONSUL \
        -template "$CT_FILE_PATH:$NX_FILE:/usr/sbin/nginx -s reload";
