FROM alpine:edge

ENV MDB_VERSION="10.3.7"

COPY ./cmake/pcre.cmake /tmp/pcre.cmake

RUN apk add --no-cache --virtual .build-dependencies build-base wget libressl-dev zlib-dev mariadb-connector-c-dev bison cmake curl-dev libaio-dev libarchive-dev libevent-dev	libxml2-dev ncurses-dev pcre-dev readline-dev xz-dev linux-headers \
 && downloadDir="$(mktemp -d)" \
 && wget -O "$downloadDir/mariadb.tar.gz" https://downloads.mariadb.org/interstitial/mariadb-$MDB_VERSION/source/mariadb-$MDB_VERSION.tar.gz \
 && buildDir="$(mktemp -d)" \
 && tar xvfz "$downloadDir/mariadb.tar.gz" -C "$buildDir" --strip-components=1 \
 && rm -rf "$downloadDir" \
 && mv -f /tmp/pcre.cmake "$buildDir/cmake/pcre.cmake" \
 && mkdir -p "$buildDir/build" \
 && cd "$buildDir/build" \
 && cmake .. \
    -DBUILD_CONFIG=mysql_release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DSYSCONFDIR=/etc/mysql \
    -DMYSQL_DATADIR=/var/lib/mysql \
    -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DENABLED_LOCAL_INFILE=ON \
    -DINSTALL_INFODIR=share/info \
    -DINSTALL_MANDIR=share/man \
    -DINSTALL_PLUGINDIR=lib/mariadb/plugin \
    -DINSTALL_SCRIPTDIR=bin \
    -DINSTALL_INCLUDEDIR=include/mysql \
    -DINSTALL_DOCREADMEDIR=share/doc/mariadb \
    -DINSTALL_SUPPORTFILESDIR=share/mariadb \
    -DINSTALL_MYSQLSHAREDIR=share/mariadb \
    -DINSTALL_DOCDIR=share/doc/mariadb \
    -DTMPDIR=/var/tmp \
    -DCONNECT_WITH_MYSQL=ON \
    -DCONNECT_WITH_LIBXML2=system \
    -DCONNECT_WITH_ODBC=NO \
    -DCONNECT_WITH_JDBC=NO \
    -DPLUGIN_ARCHIVE=YES \
    -DPLUGIN_ARIA=YES \
    -DPLUGIN_BLACKHOLE=YES \
    -DPLUGIN_CASSANDRA=NO \
    -DPLUGIN_CSV=YES \
    -DPLUGIN_MYISAM=YES \
    -DPLUGIN_MROONGA=NO \
    -DPLUGIN_OQGRAPH=NO \
    -DPLUGIN_PARTITION=YES \
    -DPLUGIN_ROCKSDB=NO \
    -DPLUGIN_SPHINX=NO \
    -DPLUGIN_TOKUDB=NO \
    -DPLUGIN_AUTH_PAM=NO \
    -DPLUGIN_AUTH_GSSAPI=NO \
    -DPLUGIN_AUTH_GSSAPI_CLIENT=NO \
    -DPLUGIN_CRACKLIB_PASSWORD_CHECK=NO \
    -DWITH_ASAN=OFF \
    -DWITH_EMBEDDED_SERVER=ON \
    -DWITH_EXTRA_CHARSETS=complex \
    -DWITH_INNODB_BZIP2=OFF \
    -DWITH_INNODB_LZ4=OFF \
    -DWITH_INNODB_LZMA=ON \
    -DWITH_INNODB_LZO=OFF \
    -DWITH_INNODB_SNAPPY=OFF \
    -DWITH_JEMALLOC=NO \
    -DWITH_LIBARCHIVE=system \
    -DWITH_LIBNUMA=NO \
    -DWITH_LIBWRAP=OFF \
    -DWITH_LIBWSEP=OFF \
    -DWITH_MARIABACKUP=ON \
    -DWITH_PCRE=system \
    -DWITH_READLINE=ON \
    -DWITH_SYSTEMD=no \
    -DWITH_SSL=system \
    -DWITH_VALGRIND=OFF \
    -DWITH_ZLIB=system \
    -DSKIP_TESTS=ON \
    -WITHOUT_SERVER=ON \
 && make
