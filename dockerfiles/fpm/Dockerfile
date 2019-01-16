FROM php:7.3-fpm

LABEL maintainer="Daniel Costa <github.com/danielcosta>"

#ENV http_proxy ${http_proxy}
#ENV https_proxy ${https_proxy}

ARG PHALCON_VERSION=3.4.2
ARG PHALCON_EXT_PATH=php7/64bits
# ARG PSR_VERSION=0.6.1

# Download things
RUN set -xe && \
    # Download PSR extension
    # curl -LO -k https://pecl.php.net/get/psr-${PSR_VERSION}.tgz && \
    # Download Phalcon extension
    curl -LO -k https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz

# RUN set -xe && \
#         # Compile PSR
#         tar xzf ${PWD}/psr-${PSR_VERSION}.tgz && \
#         docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) ${PWD}/psr-${PSR_VERSION} && \
#         rm -r \
#             ${PWD}/psr-${PSR_VERSION}.tgz \
#             ${PWD}/psr-${PSR_VERSION} && \
#         # PSR extension needs to be loaded before Phalcon's
#         mv /usr/local/etc/php/conf.d/docker-php-ext-psr.ini /usr/local/etc/php/conf.d/docker-php-ext-0-psr.ini

RUN set -xe && \
        # Compile Phalcon
        tar xzf ${PWD}/v${PHALCON_VERSION}.tar.gz && \
        docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) ${PWD}/cphalcon-${PHALCON_VERSION}/build/${PHALCON_EXT_PATH} && \
        # Remove all temp files
        rm -r \
            ${PWD}/v${PHALCON_VERSION}.tar.gz \
            ${PWD}/cphalcon-${PHALCON_VERSION}

COPY docker-phalcon-* /usr/local/bin/
