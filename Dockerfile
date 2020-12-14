FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN  apt-get update && \
     apt-get -y install \
             software-properties-common

RUN apt-get install rsync grsync  -y
RUN apt-get install ssh  -y
RUN apt-get install webp  -y
RUN apt-get install mysql-client  -y
RUN apt-get install unzip  -y

# Install nginx and  PHP-FPM
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install \
            zip \
            curl \
            nginx \
            php7.4-fpm \
            php7.4-mysql \
            php7.4-curl \
            php7.4-gd \
            php7.4-imagick \
            php7.4-cli \
            php7.4-mbstring \
            php7.4-zip \
            php7.4-xml \
            php7.4-xdebug \
            php7.4-pcov \
            php7.4-redis \
       --no-install-recommends && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    composer clear-cache

# Install NodeJS and yarn
RUN apt -y install dirmngr apt-transport-https lsb-release ca-certificates

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt -y install nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list  && \
apt update -y  && \
apt install yarn -y

COPY image-files/ /

RUN rm ~/.ssh -rf
RUN mkdir ~/.ssh && ln -s /run/secrets/host_ssh_key ~/.ssh/id_rsa

WORKDIR /var/www/public

EXPOSE 80
EXPOSE 9000

RUN usermod -u 1000 www-data
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

 CMD service php7.4-fpm start && nginx
