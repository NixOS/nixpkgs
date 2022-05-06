{ lib, stdenv, fetchurl, nixosTests, buildPackages
# Native buildInputs components
, bison, boost, cmake, fixDarwinDylibNames, flex, makeWrapper, pkg-config
# Common components
, curl, libiconv, ncurses, openssl, pcre, pcre2
, libkrb5, libaio, liburing, systemd
, CoreServices, cctools, perl
, jemalloc, less, libedit
# Server components
, bzip2, lz4, lzo, snappy, xz, zlib, zstd
, cracklib, judy, libevent, libxml2
, linux-pam, numactl, pmdk
, fmt_8
, withStorageMroonga ? true, kytea, libsodium, msgpack, zeromq
, withStorageRocks ? true
}:

let

libExt = stdenv.hostPlatform.extensions.sharedLibrary;

mytopEnv = buildPackages.perl.withPackages (p: with p; [ DBDmysql DBI TermReadKey ]);

mariadbPackage = packageSettings: (server packageSettings) // {
  client = client packageSettings; # MariaDB Client
  server = server packageSettings; # MariaDB Server
};

commonOptions = packageSettings: rec { # attributes common to both builds
  inherit (packageSettings) version;

  src = fetchurl {
    url = "https://downloads.mariadb.com/MariaDB/mariadb-${version}/source/mariadb-${version}.tar.gz";
    inherit (packageSettings) sha256;
  };

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) makeWrapper;

  buildInputs = [
    curl libiconv ncurses openssl zlib
  ] ++ (packageSettings.extraBuildInputs or [])
    ++ lib.optionals stdenv.hostPlatform.isLinux ([ libkrb5 systemd ]
    ++ (if (lib.versionOlder version "10.6") then [ libaio ] else [ liburing ]))
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices cctools perl libedit ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) [ jemalloc ]
    ++ (if (lib.versionOlder version "10.5") then [ pcre ] else [ pcre2 ]);

  prePatch = ''
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '';

  patches = [
    ./patch/cmake-includedir.patch
  ]
  # Fixes a build issue as documented on
  # https://jira.mariadb.org/browse/MDEV-26769?focusedCommentId=206073&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-206073
  ++ lib.optional (!stdenv.hostPlatform.isLinux && lib.versionAtLeast version "10.6") ./patch/macos-MDEV-26769-regression-fix.patch;

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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    rm -f "$out"/bin/{mariadb-config,mariadb_config,mysql_config}
    rm -r $out/include
    rm -r $out/lib/pkgconfig
  '';

  # perlPackages.DBDmysql is broken on darwin
  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapProgram $out/bin/mytop --set PATH ${lib.makeBinPath [ less ncurses ]}
  '';

  passthru.tests = let
    testVersion = "mariadb_${builtins.replaceStrings ["."] [""] (lib.versions.majorMinor (packageSettings.version))}";
  in {
    mariadb-galera-rsync = nixosTests.mariadb-galera.${testVersion};
    mysql = nixosTests.mysql.${testVersion};
    mysql-autobackup = nixosTests.mysql-autobackup.${testVersion};
    mysql-backup = nixosTests.mysql-backup.${testVersion};
    mysql-replication = nixosTests.mysql-replication.${testVersion};
  };

  meta = with lib; {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = "https://mariadb.org/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ thoughtpolice ajs124 das_j ];
    platforms   = platforms.all;
  };
};

client = packageSettings: let
  common = commonOptions packageSettings;

in stdenv.mkDerivation (common // {
  pname = "mariadb-client";

  outputs = [ "out" "man" ];

  patches = common.patches ++ [
    ./patch/cmake-plugin-includedir.patch
  ];

  cmakeFlags = common.cmakeFlags ++ [
    "-DPLUGIN_AUTH_PAM=NO"
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

server = packageSettings: let
  common = commonOptions packageSettings;

in stdenv.mkDerivation (common // {
  pname = "mariadb-server";

  outputs = [ "out" "man" ];

  nativeBuildInputs = common.nativeBuildInputs ++ [ bison boost.dev flex ];

  buildInputs = common.buildInputs ++ [
    bzip2 lz4 lzo snappy xz zstd
    cracklib judy libevent libxml2
  ] ++ lib.optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32) numactl
    ++ lib.optionals stdenv.hostPlatform.isLinux [ linux-pam ]
    ++ lib.optional (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) pmdk.dev
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) mytopEnv
    ++ lib.optionals withStorageMroonga [ kytea libsodium msgpack zeromq ]
    ++ lib.optionals (lib.versionAtLeast common.version "10.7") [ fmt_8 ];

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
  ] ++ lib.optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32) [
    "-DWITH_NUMA=ON"
  ] ++ lib.optional (!withStorageMroonga) [
    "-DWITHOUT_MROONGA=1"
  ] ++ lib.optional (!withStorageRocks) [
    "-DWITHOUT_ROCKSDB=1"
  ] ++ lib.optional (!stdenv.hostPlatform.isDarwin && withStorageRocks) [
    "-DWITH_ROCKSDB_JEMALLOC=ON"
  ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) [
    "-DWITH_JEMALLOC=yes"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DPLUGIN_AUTH_PAM=NO"
    "-DPLUGIN_AUTH_PAM_V1=NO"
    "-DWITHOUT_OQGRAPH=1"
    "-DWITHOUT_PLUGIN_S3=1"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # revisit this if nixpkgs supports any architecture whose stack grows upwards
    "-DSTACK_DIRECTION=-1"
    "-DCMAKE_CROSSCOMPILING_EMULATOR=${stdenv.hostPlatform.emulator buildPackages}"
  ];

  preConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchShebangs scripts/mytop.sh
  '';

  postInstall = common.postInstall + ''
    rm -r "$out"/share/aclocal
    chmod +x "$out"/bin/wsrep_sst_common
    rm -f "$out"/bin/{mariadb-client-test,mariadb-test,mysql_client_test,mysqltest}
  '' + lib.optionalString withStorageMroonga ''
    mv "$out"/share/{groonga,groonga-normalizer-mysql} "$out"/share/doc/mysql
  '' + lib.optionalString (!stdenv.hostPlatform.isDarwin && lib.versionAtLeast common.version "10.4") ''
    mv "$out"/OFF/suite/plugins/pam/pam_mariadb_mtr.so "$out"/share/pam/lib/security
    mv "$out"/OFF/suite/plugins/pam/mariadb_mtr "$out"/share/pam/etc/security
    rm -r "$out"/OFF
  '';

  CXXFLAGS = lib.optionalString stdenv.hostPlatform.isi686 "-fpermissive";
});
in {
  mariadb_104 = mariadbPackage {
    # Supported until 2024-06-18
    version = "10.4.24";
    sha256 = "0ipqilri8isn0mfvwg8imwf36zm3jsw0wf2yx905c2bznd8mb5zy";
  };
  mariadb_105 = mariadbPackage {
    # Supported until 2025-06-24
    version = "10.5.15";
    sha256 = "0nfvyxb157qsbl0d1i5gfzr2hb1nm0iv58f7qcbk5kkhz0vyv049";
  };
  mariadb_106 = mariadbPackage {
    # Supported until 2026-07
    version = "10.6.7";
    sha256 = "1idjnkjfkjvyr6r899xbiwq9wwbs84cm85mbc725yxjshqghzvkm";
  };
  mariadb_107 = mariadbPackage {
    # Supported until 2023-02
    version = "10.7.3";
    sha256 = "1m2wa67vvdm61ap8spl18b9vqkmsnq4rfd0248l17jf9zwcnja6s";
  };
  mariadb_108 = mariadbPackage {
    # Supported until 2023-05
    version = "10.8.2";
    sha256 = "0v4mms3mihylnqlc0ifvwzykah6lkdd39lmxbv5vnhbsh7wggq0l";
  };
}
