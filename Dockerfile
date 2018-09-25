FROM huggla/mariadb:10.3.9 as stage2
FROM huggla/alpine-slim:20180921-edge as stage1

ARG APKS="mariadb-client libressl2.7-libssl"

COPY --from=stage2 /mariadb-apks /mariadb-apks

RUN mkdir -p /rootfs/usr/local/bin \
 && echo /mariadb-apks >> /etc/apk/repositories \
 && apk --no-cache --allow-untrusted add $APKS \
 && apk --no-cache --quiet info > /apks.list \
 && apk --no-cache --quiet manifest $(cat /apks.list) | awk -F "  " '{print $2;}' > /apks_files.list \
 && tar -cvp -f /apks_files.tar -T /apks_files.list -C / \
 && tar -xvp -f /apks_files.tar -C /rootfs/ \
 && rm -rf /mariadb-apks \
 && cp -a /rootfs/usr/bin/mysql /rootfs/usr/local/bin/mysql \
 && cd /rootfs/usr/bin \
 && ln -fs ../local/bin/mysql mysql

FROM huggla/base

ENV VAR_LINUX_USER="mysql"

ONBUILD USER root
