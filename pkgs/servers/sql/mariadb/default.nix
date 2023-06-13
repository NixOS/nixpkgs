let
  # shared across all versions
  generic =
    { version, hash
    , lib, stdenv, fetchurl, nixosTests, buildPackages
    # Native buildInputs components
    , bison, boost, cmake, fixDarwinDylibNames, flex, makeWrapper, pkg-config
    # Common components
    , curl, libiconv, ncurses, openssl, openssl_1_1, pcre, pcre2
    , libkrb5, libaio, liburing, systemd
    , CoreServices, cctools, perl
    , jemalloc, less, libedit
    # Server components
    , bzip2, lz4, lzo, snappy, xz, zlib, zstd
    , cracklib, judy, libevent, libxml2
    , linux-pam, numactl
    , fmt_8
    , withStorageMroonga ? true, kytea, libsodium, msgpack, zeromq
    , withStorageRocks ? true
    , withEmbedded ? false
    , withNuma ? false
    }:

  let
    isCross = stdenv.buildPlatform != stdenv.hostPlatform;

    libExt = stdenv.hostPlatform.extensions.sharedLibrary;

    mytopEnv = buildPackages.perl.withPackages (p: with p; [ DBDmysql DBI TermReadKey ]);

    common = rec { # attributes common to both builds
      inherit version;

      src = fetchurl {
        url = "https://downloads.mariadb.com/MariaDB/mariadb-${version}/source/mariadb-${version}.tar.gz";
        inherit hash;
      };

      outputs = [ "out" "man" ];

      nativeBuildInputs = [ cmake pkg-config ]
        ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
        ++ lib.optional (!stdenv.hostPlatform.isDarwin) makeWrapper;

      buildInputs = [
        libiconv ncurses zlib
      ] ++ lib.optionals stdenv.hostPlatform.isLinux ([ libkrb5 systemd ]
        ++ (if (lib.versionOlder version "10.6") then [ libaio ] else [ liburing ]))
        ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices cctools perl libedit ]
        ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ jemalloc ]
        ++ (if (lib.versionOlder version "10.5") then [ pcre ] else [ pcre2 ])
        ++ (if (lib.versionOlder version "10.5")
            then [ openssl_1_1 (curl.override { openssl = openssl_1_1; }) ]
            else [ openssl curl ]);

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
        "-DMANUFACTURER=nixos.org"
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
      ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && lib.versionAtLeast version "10.6") [
        # workaround for https://jira.mariadb.org/browse/MDEV-29925
        "-Dhave_C__Wl___as_needed="
      ] ++ lib.optionals isCross [
        # revisit this if nixpkgs supports any architecture whose stack grows upwards
        "-DSTACK_DIRECTION=-1"
        "-DCMAKE_CROSSCOMPILING_EMULATOR=${stdenv.hostPlatform.emulator buildPackages}"
      ];

      postInstall = lib.optionalString (!withEmbedded) ''
        # Remove Development components. Need to use libmysqlclient.
        rm "$out"/lib/mysql/plugin/daemon_example.ini
        rm "$out"/lib/{libmariadb.a,libmariadbclient.a,libmysqlclient.a,libmysqlclient_r.a,libmysqlservices.a}
        rm -f "$out"/bin/{mariadb-config,mariadb_config,mysql_config}
        rm -r $out/include
        rm -r $out/lib/pkgconfig
      '';

      # perlPackages.DBDmysql is broken on darwin
      postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
        wrapProgram $out/bin/mytop --set PATH ${lib.makeBinPath [ less ncurses ]}
      '';

      passthru.tests = let
        testVersion = "mariadb_${builtins.replaceStrings ["."] [""] (lib.versions.majorMinor version)}";
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

    client = stdenv.mkDerivation (common // {
      pname = "mariadb-client";

      patches = common.patches ++ [
        ./patch/cmake-plugin-includedir.patch
      ];

      buildInputs = common.buildInputs
        ++ lib.optionals (lib.versionAtLeast common.version "10.7") [ fmt_8 ];

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

    server = stdenv.mkDerivation (common // {
      pname = "mariadb-server";

      nativeBuildInputs = common.nativeBuildInputs ++ [ bison boost.dev flex ];

      buildInputs = common.buildInputs ++ [
        bzip2 lz4 lzo snappy xz zstd
        cracklib judy libevent libxml2
      ] ++ lib.optional withNuma numactl
        ++ lib.optionals stdenv.hostPlatform.isLinux [ linux-pam ]
        ++ lib.optional (!stdenv.hostPlatform.isDarwin) mytopEnv
        ++ lib.optionals withStorageMroonga [ kytea libsodium msgpack zeromq ]
        ++ lib.optionals (lib.versionAtLeast common.version "10.7") [ fmt_8 ];

      propagatedBuildInputs = lib.optional withNuma numactl;

      postPatch = ''
        substituteInPlace scripts/galera_new_cluster.sh \
          --replace ":-mariadb" ":-mysql"
      '';

      cmakeFlags = common.cmakeFlags ++ [
        "-DMYSQL_DATADIR=/var/lib/mysql"
        "-DENABLED_LOCAL_INFILE=OFF"
        "-DWITH_READLINE=ON"
        "-DWITH_EXTRA_CHARSETS=all"
        "-DWITH_EMBEDDED_SERVER=${if withEmbedded then "ON" else "OFF"}"
        "-DWITH_UNIT_TESTS=OFF"
        "-DWITH_WSREP=ON"
        "-DWITH_INNODB_DISALLOW_WRITES=ON"
        "-DWITHOUT_EXAMPLE=1"
        "-DWITHOUT_FEDERATED=1"
        "-DWITHOUT_TOKUDB=1"
      ] ++ lib.optionals withNuma [
        "-DWITH_NUMA=ON"
      ] ++ lib.optionals (!withStorageMroonga) [
        "-DWITHOUT_MROONGA=1"
      ] ++ lib.optionals (!withStorageRocks) [
        "-DWITHOUT_ROCKSDB=1"
      ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin && withStorageRocks) [
        "-DWITH_ROCKSDB_JEMALLOC=ON"
      ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        "-DWITH_JEMALLOC=yes"
      ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "-DPLUGIN_AUTH_PAM=NO"
        "-DPLUGIN_AUTH_PAM_V1=NO"
        "-DWITHOUT_OQGRAPH=1"
        "-DWITHOUT_PLUGIN_S3=1"
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
      NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isRiscV "-latomic";
    });
  in
    server // {
      inherit client server;
    };
in
  self: {
    # see https://mariadb.org/about/#maintenance-policy for EOLs
    mariadb_104 = self.callPackage generic {
      # Supported until 2024-06-18
      version = "10.4.29";
      hash = "sha256-Wy0zh5LnnmjWpUXisVYDu792GMc55fgg9XsdayIJITA=";
      inherit (self.darwin) cctools;
      inherit (self.darwin.apple_sdk.frameworks) CoreServices;
    };
    mariadb_105 = self.callPackage generic {
      # Supported until 2025-06-24
      version = "10.5.20";
      hash = "sha256-sY+Q8NAR74e71VmtBDLN4Qfs21jqKCcQg7SJvf0e79s=";
      inherit (self.darwin) cctools;
      inherit (self.darwin.apple_sdk.frameworks) CoreServices;
    };
    mariadb_106 = self.callPackage generic {
      # Supported until 2026-07-06
      version = "10.6.13";
      hash = "sha256-8IXzec9Z7S02VkT8XNhVj4gqiG7JZAcNZaKFMN27dbo=";
      inherit (self.darwin) cctools;
      inherit (self.darwin.apple_sdk.frameworks) CoreServices;
    };
    mariadb_1010 = self.callPackage generic {
      # Supported until 2023-11-17. TODO: remove ahead of 23.11 branchoff
      version = "10.10.4";
      hash = "sha256-IX2Z47Ami5MizyicGEMnqHiYs/aGvS6eS5JpXqYRixk=";
      inherit (self.darwin) cctools;
      inherit (self.darwin.apple_sdk.frameworks) CoreServices;
    };
    mariadb_1011 = self.callPackage generic {
      # Supported until 2028-02-16
      version = "10.11.3";
      hash = "sha256-sGWw8ypun9R55Wb9ZnFFA3mIbY3aLZp++TCvHlwmwMc=";
      inherit (self.darwin) cctools;
      inherit (self.darwin.apple_sdk.frameworks) CoreServices;
    };
    mariadb_110 = self.callPackage generic {
      # Supported until 2024-06-07
      version = "11.0.2";
      hash = "sha256-PHFXbK0OpBaIInDjg/lMyJaTt/vM4fpPMG/j6THkZK4=";
      inherit (self.darwin) cctools;
      inherit (self.darwin.apple_sdk.frameworks) CoreServices;
    };
  }
