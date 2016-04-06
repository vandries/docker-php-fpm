FROM centos:7

MAINTAINER Valentin Andriès <valentin.andries@music-story.com>

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y update

RUN yum -y install --enablerepo=remi,remi-php55 \
    php-fpm \
    php-cli \
    php-xml \
    php-mcrypt \
    php-mysql \
    php-pecl-apc \
    php-gd \
    php-pecl-imagick \
    php-curl \
    php-intl \
    php-mbstring \
    php-pecl-xdebug
RUN yum clean all

ADD musicstory.ini /etc/php.d/
#ADD www.pool.conf /etc/php-fpm.d/
RUN rm /etc/php-fpm.d/www.conf

RUN cp /etc/hosts /tmp/hosts
RUN mkdir -p -- /lib-override && cp /lib64/libnss_files.so.2 /lib-override
RUN sed -i 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2
ENV LD_LIBRARY_PATH /lib-override
RUN echo "195.190.27.13    mstory1 mstory2" >> /tmp/hosts
RUN echo "194.213.30.37    mstory3 mstory4" >> /tmp/hosts

CMD ["php-fpm", "-F"]

VOLUME "/etc/php-fpm.d"

EXPOSE 9000
