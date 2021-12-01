{ lib, stdenv, fetchurl, nixosTests
# Native buildInputs components
, bison, boost, cmake, fixDarwinDylibNames, flex, makeWrapper, pkg-config
# Common components
, curl, libiconv, ncurses, openssl, pcre2
, libkrb5, liburing, systemd
, CoreServices, cctools, perl
, jemalloc, less
# Server components
, bzip2, lz4, lzo, snappy, xz, zlib, zstd
, cracklib, judy, libevent, libxml2
, linux-pam, numactl, pmdk
, withStorageMroonga ? true, kytea, libsodium, msgpack, zeromq
, withStorageRocks ? true
}:

with lib;

let # in mariadb # spans the whole file

libExt = stdenv.hostPlatform.extensions.sharedLibrary;

mytopEnv = perl.withPackages (p: with p; [ DBDmysql DBI TermReadKey ]);

mariadb = server // {
  inherit client; # MariaDB Client
  server = server; # MariaDB Server
};

common = rec { # attributes common to both builds
  version = "10.6.5";

  src = fetchurl {
    url = "https://downloads.mariadb.com/MariaDB/mariadb-${version}/source/mariadb-${version}.tar.gz";
    sha256 = "sha256-4L4EBCjZpCqLtL0iG1Z/8lIs1vqJBjhic9pPA8XCCo8=";
  };

  nativeBuildInputs = [ cmake pkg-config ]
    ++ optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
    ++ optional (!stdenv.hostPlatform.isDarwin) makeWrapper;

  buildInputs = [
    curl libiconv ncurses openssl pcre2 zlib
  ] ++ optionals stdenv.hostPlatform.isLinux [ libkrb5 liburing systemd ]
    ++ optionals stdenv.hostPlatform.isDarwin [ CoreServices cctools perl ]
    ++ optional (!stdenv.hostPlatform.isDarwin) [ jemalloc ];

  prePatch = ''
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '';

  patches = [
    ./patch/cmake-includedir.patch
  ]
  # Fixes a build issue as documented on
  # https://jira.mariadb.org/browse/MDEV-26769?focusedCommentId=206073&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-206073
  ++ lib.optional (!stdenv.isLinux) ./patch/macos-MDEV-26769-regression-fix.patch;

  cmakeFlags = [
    "-DBUILD_CONFIG=mysql_release"
    "-DMANUFACTURER=NixOS.org"
    "-DDEFAULT_CHARSET=utf8mb4"
    "-DDEFAULT_COLLATION=utf8mb4_unicode_ci"
    "-DSECURITY_HARDENED=ON"

    "-DINSTALL_UNIX_ADDRDIR=/run/mysqld/mysqld.sock"
    "-DINSTALL_BINDIR=bin"
    "-DINSTALL_DOCDIR=share/doc/mysql"
    "-DINSTALL_DOCREADMEDIR=share/doc/mysql"
    "-DINSTALL_INCLUDEDIR=include/mysql"
    "-DINSTALL_LIBDIR=lib"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
    "-DINSTALL_SCRIPTDIR=bin"
    "-DINSTALL_SUPPORTFILESDIR=share/doc/mysql"
    "-DINSTALL_MYSQLTESTDIR=OFF"
    "-DINSTALL_SQLBENCHDIR=OFF"
    "-DINSTALL_PAMDIR=share/pam/lib/security"
    "-DINSTALL_PAMDATADIR=share/pam/etc/security"

    "-DWITH_ZLIB=system"
    "-DWITH_SSL=system"
    "-DWITH_PCRE=system"
    "-DWITH_SAFEMALLOC=OFF"
    "-DWITH_UNIT_TESTS=OFF"
    "-DEMBEDDED_LIBRARY=OFF"
  ] ++ optionals stdenv.hostPlatform.isDarwin [
    # On Darwin without sandbox, CMake will find the system java and attempt to build with java support, but
    # then it will fail during the actual build. Let's just disable the flag explicitly until someone decides
    # to pass in java explicitly.
    "-DCONNECT_WITH_JDBC=OFF"
    "-DCURSES_LIBRARY=${ncurses.out}/lib/libncurses.dylib"
  ];

  postInstall = ''
    # Remove Development components. Need to use libmysqlclient.
    rm "$out"/lib/mysql/plugin/daemon_example.ini
    rm "$out"/lib/{libmariadbclient.a,libmysqlclient.a,libmysqlclient_r.a,libmysqlservices.a}
    rm "$out"/bin/{mariadb-config,mariadb_config,mysql_config}
    rm -r $out/include
    rm -r $out/lib/pkgconfig
  '';

  # perlPackages.DBDmysql is broken on darwin
  postFixup = optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapProgram $out/bin/mytop --set PATH ${makeBinPath [ less ncurses ]}
  '';

  passthru.mysqlVersion = "5.7";

  passthru.tests = {
    mariadb-galera-mariabackup = nixosTests.mariadb-galera-mariabackup;
    mariadb-galera-rsync = nixosTests.mariadb-galera-rsync;
    mysql = nixosTests.mysql;
    mysql-autobackup = nixosTests.mysql-autobackup;
    mysql-backup = nixosTests.mysql-backup;
    mysql-replication = nixosTests.mysql-replication;
  };

  meta = {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = "https://mariadb.org/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.all;
  };
};

client = stdenv.mkDerivation (common // {
  pname = "mariadb-client";

  outputs = [ "out" "man" ];

  patches = common.patches ++ [
    ./patch/cmake-plugin-includedir.patch
  ];

  cmakeFlags = common.cmakeFlags ++ [
    "-DPLUGIN_AUTH_PAM=OFF"
    "-DWITHOUT_SERVER=ON"
    "-DWITH_WSREP=OFF"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql-client"
  ];

  postInstall = common.postInstall + ''
    rm "$out"/bin/{mariadb-test,mysqltest}
    libmysqlclient_path=$(readlink -f $out/lib/libmysqlclient${libExt})
    rm "$out"/lib/{libmariadb${libExt},libmysqlclient${libExt},libmysqlclient_r${libExt}}
    mv "$libmysqlclient_path" "$out"/lib/libmysqlclient${libExt}
    ln -sv libmysqlclient${libExt} "$out"/lib/libmysqlclient_r${libExt}
  '';
});

server = stdenv.mkDerivation (common // {
  pname = "mariadb-server";

  outputs = [ "out" "man" ];

  nativeBuildInputs = common.nativeBuildInputs ++ [ bison boost.dev flex ];

  buildInputs = common.buildInputs ++ [
    bzip2 lz4 lzo snappy xz zstd
    cracklib judy libevent libxml2
  ] ++ optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32) numactl
    ++ optionals stdenv.hostPlatform.isLinux [ linux-pam ]
    ++ optional (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) pmdk.dev
    ++ optional (!stdenv.hostPlatform.isDarwin) mytopEnv
    ++ optionals withStorageMroonga [ kytea libsodium msgpack zeromq ];

  patches = common.patches;

  postPatch = ''
    substituteInPlace scripts/galera_new_cluster.sh \
      --replace ":-mariadb" ":-mysql"
  '';

  cmakeFlags = common.cmakeFlags ++ [
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DENABLED_LOCAL_INFILE=OFF"
    "-DWITH_READLINE=ON"
    "-DWITH_EXTRA_CHARSETS=all"
    "-DWITH_EMBEDDED_SERVER=OFF"
    "-DWITH_UNIT_TESTS=OFF"
    "-DWITH_WSREP=ON"
    "-DWITH_INNODB_DISALLOW_WRITES=ON"
    "-DWITHOUT_EXAMPLE=1"
    "-DWITHOUT_FEDERATED=1"
    "-DWITHOUT_TOKUDB=1"
  ] ++ optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32) [
    "-DWITH_NUMA=ON"
  ] ++ optional (!withStorageMroonga) [
    "-DWITHOUT_MROONGA=1"
  ] ++ optional (!withStorageRocks) [
    "-DWITHOUT_ROCKSDB=1"
  ] ++ optional (!stdenv.hostPlatform.isDarwin && withStorageRocks) [
    "-DWITH_ROCKSDB_JEMALLOC=ON"
  ] ++ optional (!stdenv.hostPlatform.isDarwin) [
    "-DWITH_JEMALLOC=yes"
  ] ++ optionals stdenv.hostPlatform.isDarwin [
    "-DPLUGIN_AUTH_PAM=OFF"
    "-DWITHOUT_OQGRAPH=1"
    "-DWITHOUT_PLUGIN_S3=1"
  ];

  preConfigure = optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchShebangs scripts/mytop.sh
  '';

  postInstall = common.postInstall + ''
    rm -r "$out"/share/aclocal
    chmod +x "$out"/bin/wsrep_sst_common
    rm "$out"/bin/{mariadb-client-test,mariadb-test,mysql_client_test,mysqltest}
  '' + optionalString withStorageMroonga ''
    mv "$out"/share/{groonga,groonga-normalizer-mysql} "$out"/share/doc/mysql
  '' + optionalString (!stdenv.hostPlatform.isDarwin) ''
    mv "$out"/OFF/suite/plugins/pam/pam_mariadb_mtr.so "$out"/share/pam/lib/security
    mv "$out"/OFF/suite/plugins/pam/mariadb_mtr "$out"/share/pam/etc/security
    rm -r "$out"/OFF
  '';

  CXXFLAGS = optionalString stdenv.hostPlatform.isi686 "-fpermissive";
});
in mariadb
