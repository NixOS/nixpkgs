let
  # shared across all versions
  generic =
    {
      version,
      hash,
      lib,
      stdenv,
      fetchurl,
      nixosTests,
      buildPackages,
      # Native buildInputs components
      bison,
      boost,
      cmake,
      fixDarwinDylibNames,
      flex,
      makeWrapper,
      pkg-config,
      # Common components
      curl,
      libiconv,
      ncurses,
      openssl,
      pcre2,
      libkrb5,
      libaio,
      liburing,
      systemd,
      cctools,
      perl,
      jemalloc,
      less,
      libedit,
      # Server components
      bzip2,
      lz4,
      lzo,
      snappy,
      xz,
      zlib,
      zstd,
      cracklib,
      judy,
      libevent,
      libxml2,
      linux-pam,
      numactl,
      fmt_11,
      withStorageMroonga ? true,
      kytea,
      libsodium,
      msgpack,
      zeromq,
      withStorageRocks ? true,
      withEmbedded ? false,
      withNuma ? false,
    }:

    let
      isCross = stdenv.buildPlatform != stdenv.hostPlatform;

      libExt = stdenv.hostPlatform.extensions.sharedLibrary;

      mytopEnv = buildPackages.perl.withPackages (
        p: with p; [
          DBDMariaDB
          DBI
          TermReadKey
        ]
      );

      common = rec {
        # attributes common to both builds
        inherit version;

        src = fetchurl {
          url = "https://archive.mariadb.org/mariadb-${version}/source/mariadb-${version}.tar.gz";
          inherit hash;
        };

        outputs = [
          "out"
          "man"
        ];

        nativeBuildInputs = [
          cmake
          pkg-config
        ]
        ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
        ++ lib.optional (!stdenv.hostPlatform.isDarwin) makeWrapper;

        buildInputs = [
          libiconv
          ncurses
          zlib
          pcre2
          openssl
          curl
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux (
          [
            libkrb5
            systemd
          ]
          ++ (if (lib.versionOlder version "10.6") then [ libaio ] else [ liburing ])
        )
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          cctools
          perl
          libedit
        ]
        ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ jemalloc ];

        prePatch = ''
          sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
        '';
        env = lib.optionalAttrs (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isGnu) {
          # MariaDB uses non-POSIX fopen64, which musl only conditionally defines.
          NIX_CFLAGS_COMPILE = "-D_LARGEFILE64_SOURCE";
        };

        patches = [
          ./patch/cmake-includedir.patch
          # patch for musl compatibility
          ./patch/include-cstdint-full.patch
        ]
        # Fixes a build issue as documented on
        # https://jira.mariadb.org/browse/MDEV-26769?focusedCommentId=206073&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-206073
        ++ lib.optional (
          !stdenv.hostPlatform.isLinux && lib.versionAtLeast version "10.6"
        ) ./patch/macos-MDEV-26769-regression-fix.patch;

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
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # On Darwin without sandbox, CMake will find the system java and attempt to build with java support, but
          # then it will fail during the actual build. Let's just disable the flag explicitly until someone decides
          # to pass in java explicitly.
          "-DCONNECT_WITH_JDBC=OFF"
          "-DCURSES_LIBRARY=${ncurses.out}/lib/libncurses.dylib"
        ]
        ++ lib.optionals (stdenv.hostPlatform.isDarwin && lib.versionAtLeast version "10.6") [
          # workaround for https://jira.mariadb.org/browse/MDEV-29925
          "-Dhave_C__Wl___as_needed="
        ]
        ++ lib.optionals isCross [
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
          wrapProgram $out/bin/mytop --set PATH ${
            lib.makeBinPath [
              less
              ncurses
            ]
          }
        '';

        passthru.tests =
          let
            testVersion = "mariadb_${builtins.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor version)}";
          in
          {
            mariadb-galera-rsync = nixosTests.mariadb-galera.${testVersion};
            mysql = nixosTests.mysql.${testVersion};
            mysql-autobackup = nixosTests.mysql-autobackup.${testVersion};
            mysql-backup = nixosTests.mysql-backup.${testVersion};
            mysql-replication = nixosTests.mysql-replication.${testVersion};
          };

        meta = with lib; {
          description = "Enhanced, drop-in replacement for MySQL";
          homepage = "https://mariadb.org/";
          license = licenses.gpl2Plus;
          maintainers = with maintainers; [ thoughtpolice ];
          teams = [ teams.helsinki-systems ];
          platforms = platforms.all;
        };
      };

      client = stdenv.mkDerivation (
        common
        // {
          pname = "mariadb-client";

          patches = common.patches ++ [
            ./patch/cmake-plugin-includedir.patch
          ];

          buildInputs =
            common.buildInputs ++ lib.optionals (lib.versionAtLeast common.version "10.11") [ fmt_11 ];

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
        }
      );
    in

    stdenv.mkDerivation (
      finalAttrs:
      common
      // {
        pname = "mariadb-server";

        nativeBuildInputs = common.nativeBuildInputs ++ [
          bison
          boost.dev
          flex
        ];

        buildInputs =
          common.buildInputs
          ++ [
            bzip2
            lz4
            lzo
            snappy
            xz
            zstd
            cracklib
            judy
            libevent
            libxml2
          ]
          ++ lib.optional withNuma numactl
          ++ lib.optionals stdenv.hostPlatform.isLinux [ linux-pam ]
          ++ lib.optional (!stdenv.hostPlatform.isDarwin) mytopEnv
          ++ lib.optionals withStorageMroonga [
            kytea
            libsodium
            msgpack
            zeromq
          ]
          ++ lib.optionals (lib.versionAtLeast common.version "10.11") [ fmt_11 ];

        propagatedBuildInputs = lib.optional withNuma numactl;

        postPatch = ''
          substituteInPlace scripts/galera_new_cluster.sh \
            --replace ":-mariadb" ":-mysql"
        '';

        cmakeFlags =
          common.cmakeFlags
          ++ [
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
          ]
          ++ lib.optionals (lib.versionOlder version "11.4") [
            # Fix the build with CMake 4.
            "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
          ]
          ++ lib.optionals withNuma [
            "-DWITH_NUMA=ON"
          ]
          ++ lib.optionals (!withStorageMroonga) [
            "-DWITHOUT_MROONGA=1"
          ]
          ++ lib.optionals (!withStorageRocks) [
            "-DWITHOUT_ROCKSDB=1"
          ]
          ++ lib.optionals (!stdenv.hostPlatform.isDarwin && withStorageRocks) [
            "-DWITH_ROCKSDB_JEMALLOC=ON"
          ]
          ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
            "-DWITH_JEMALLOC=yes"
          ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            "-DPLUGIN_AUTH_PAM=NO"
            "-DPLUGIN_AUTH_PAM_V1=NO"
            "-DWITHOUT_OQGRAPH=1"
            "-DWITHOUT_PLUGIN_S3=1"
          ];

        preConfigure = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
          patchShebangs scripts/mytop.sh
        '';

        postInstall =
          common.postInstall
          + ''
            rm -r "$out"/share/aclocal
            chmod +x "$out"/bin/wsrep_sst_common
            rm -f "$out"/bin/{mariadb-client-test,mariadb-test,mysql_client_test,mysqltest}
          ''
          + lib.optionalString withStorageMroonga ''
            mv "$out"/share/{groonga,groonga-normalizer-mysql} "$out"/share/doc/mysql
          ''
          + lib.optionalString (!stdenv.hostPlatform.isDarwin && lib.versionAtLeast common.version "10.4") ''
            mv "$out"/OFF/suite/plugins/pam/pam_mariadb_mtr.so "$out"/share/pam/lib/security
            mv "$out"/OFF/suite/plugins/pam/mariadb_mtr "$out"/share/pam/etc/security
            rm -r "$out"/OFF
          '';

        CXXFLAGS = lib.optionalString stdenv.hostPlatform.isi686 "-fpermissive";

        passthru = {
          inherit client;
          server = finalAttrs.finalPackage;
        };
      }
    );
in
self: {
  # see https://mariadb.org/about/#maintenance-policy for EOLs
  mariadb_106 = self.callPackage generic {
    # Supported until 2026-07-06
    version = "10.6.23";
    hash = "sha256-uvS/N6BR6JLnFyTudSiRrbfPxpzSjQhzXDYH0wxpPCM=";
  };
  mariadb_1011 = self.callPackage generic {
    # Supported until 2028-02-16
    version = "10.11.14";
    hash = "sha256-ilccsU+x1ONmPY6Y89QgDAQvyLKkqqq0lYYN6ot9BS8=";
  };
  mariadb_114 = self.callPackage generic {
    # Supported until 2029-05-29
    version = "11.4.8";
    hash = "sha256-UvpNyixfgK/BZn1SOifAYXbZhTIpimsMMe1zUF9J4Vw=";
  };
  mariadb_118 = self.callPackage generic {
    # Supported until 2028-06-04
    version = "11.8.3";
    hash = "sha256-EBSoXHaN6PnpxtS/C0JhfzsViL4a03H3FnTqMrhxGcA=";
  };
}
