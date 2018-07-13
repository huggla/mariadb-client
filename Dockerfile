FROM huggla/mariadb as stage1
FROM huggla/alpine as stage2

USER root

COPY --from=stage1 /mariadb-apks /mariadb-apks

RUN apk --no-cache --allow-untrusted add /mariadb-apks/mariadb-common.apk /mariadb-apks/mariadb-client.apk \
 && apk --no-cache add libgcc xz-libs libaio pcre libstdc++ libressl2.7-libcrypto libressl2.7-libssl \
 && tar -cpf /installed_files.tar $(apk manifest mariadb-client mariadb-common libgcc xz-libs libaio pcre libstdc++ libressl2.7-libcrypto libressl2.7-libssl | awk -F "  " '{print $2;}') \
 && tar -xpf /installed_files.tar -C /rootfs/ \
 && mkdir -p /rootfs/usr/local/bin \
 && mv /rootfs/usr/bin/mysqld /rootfs/usr/local/bin/mysqld \
 && cd /rootfs/usr/bin \
 && ln -s ../local/bin/mysqld mysqld

FROM huggla/alpine

COPY --from=stage2 /rootfs /

ENV VAR_FINAL_COMMAND="/bin/sh"
