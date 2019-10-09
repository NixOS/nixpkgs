{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, makeWrapper, ncurses, zlib, xz, lzo, lz4, bzip2, snappy
, libiconv, openssl, pcre, boost, judy, bison, libxml2, libkrb5, linux-pam, curl
, libaio, libevent, jemalloc, cracklib, systemd, numactl, perl
, fixDarwinDylibNames, cctools, CoreServices
, asio, buildEnv, check, scons
, less, fetchpatch
, withoutClient ? false
}:

with stdenv.lib;

let # in mariadb # spans the whole file

libExt = stdenv.hostPlatform.extensions.sharedLibrary;

mytopEnv = perl.withPackages (p: with p; [ DataDumper DBDmysql DBI TermReadKey ]);

mariadb = server // {
  inherit client; # MariaDB Client
  server = server; # MariaDB Server
};

common = rec { # attributes common to both builds
  version = "10.3.18";

  src = fetchurl {
    urls = [
      "https://downloads.mariadb.org/f/mariadb-${version}/source/mariadb-${version}.tar.gz"
      "https://downloads.mariadb.com/MariaDB/mariadb-${version}/source/mariadb-${version}.tar.gz"
    ];
    sha256 = "1p6yvmahnkmsz50zjzp20ak7jzbqysly5bdl51nnrngrbfl6qib9";
    name   = "mariadb-${version}.tar.gz";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    ncurses openssl zlib pcre jemalloc libiconv curl
  ] ++ optionals stdenv.isLinux [ libaio systemd libkrb5 ]
    ++ optionals stdenv.isDarwin [ perl fixDarwinDylibNames cctools CoreServices ];

  prePatch = ''
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '' + optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/build_configurations/mysql_release.cmake \
      --replace "SET(PLUGIN_AUTH_PAM YES)" ""
  '';

  patches = [
    ./cmake-includedir.patch
    ./cmake-libmariadb-includedir.patch
  ] ++ optional stdenv.hostPlatform.isDarwin (fetchpatch {
    url = "https://github.com/MariaDB/mariadb-connector-c/commit/ee91b2c98a63acb787114dee4f2694e154630928.patch";
    extraPrefix = "libmariadb/";
    sha256 = "06i865zwyhs9fvrgmargzn09pbg1cmably3c4wifd241bj8ig8qk";
    stripLen = 1;
  });

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

    "-DWITH_ZLIB=system"
    "-DWITH_SSL=system"
    "-DWITH_PCRE=system"
    "-DWITH_SAFEMALLOC=OFF"
    "-DWITH_UNIT_TESTS=OFF"
    "-DEMBEDDED_LIBRARY=OFF"
  ] ++ optionals stdenv.isDarwin [
    # On Darwin without sandbox, CMake will find the system java and attempt to build with java support, but
    # then it will fail during the actual build. Let's just disable the flag explicitly until someone decides
    # to pass in java explicitly.
    "-DCONNECT_WITH_JDBC=OFF"
    "-DCURSES_LIBRARY=${ncurses.out}/lib/libncurses.dylib"
  ] ++ optionals stdenv.hostPlatform.isMusl [
    "-DWITHOUT_TOKUDB=1" # mariadb docs say disable this for musl
  ];

  postInstall = ''
    rm "$out"/lib/mysql/plugin/daemon_example.ini
    mkdir -p "$dev"/bin && mv "$out"/bin/{mariadb_config,mysql_config} "$dev"/bin
    mkdir -p "$dev"/lib/ && mv "$out"/lib/{libmariadbclient.a,libmysqlclient.a,libmysqlclient_r.a,libmysqlservices.a} "$dev"/lib
    mkdir -p "$dev"/lib/mysql/plugin && mv "$out"/lib/mysql/plugin/{caching_sha2_password.so,dialog.so,mysql_clear_password.so,sha256_password.so} "$dev"/lib/mysql/plugin
  '';

  enableParallelBuilding = true;

  passthru.mysqlVersion = "5.7";

  meta = {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = https://mariadb.org/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.all;
  };
};

client = stdenv.mkDerivation (common // {
  pname = "mariadb-client";

  outputs = [ "out" "dev" "man" ];

  propagatedBuildInputs = [ openssl zlib ]; # required from mariadb.pc

  patches = common.patches ++ [
    ./cmake-plugin-includedir.patch
    ./cmake-without-plugin-auth-pam.patch
  ];

  cmakeFlags = common.cmakeFlags ++ [
    "-DWITHOUT_SERVER=ON"
    "-DWITH_WSREP=OFF"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql-client"
  ];

  preConfigure = ''
   cmakeFlags="$cmakeFlags \
      -DCMAKE_INSTALL_PREFIX_DEV=$dev"
  '';

  postInstall = common.postInstall + ''
    rm -r "$out"/share/doc
    rm "$out"/bin/{mysqltest,mytop,wsrep_sst_rsync_wan}
    libmysqlclient_path=$(readlink -f $out/lib/libmysqlclient${libExt})
    rm "$out"/lib/{libmariadb${libExt},libmysqlclient${libExt},libmysqlclient_r${libExt}}
    mv "$libmysqlclient_path" "$out"/lib/libmysqlclient${libExt}
    ln -sv libmysqlclient${libExt} "$out"/lib/libmysqlclient_r${libExt}
  '';
});

server = stdenv.mkDerivation (common // {
  pname = "mariadb-server";

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = common.nativeBuildInputs ++ [ bison ] ++ optional (!stdenv.isDarwin) makeWrapper;

  buildInputs = common.buildInputs ++ [
    xz lzo lz4 bzip2 snappy
    libxml2 boost judy libevent cracklib
  ] ++ optional (stdenv.isLinux && !stdenv.isAarch32) numactl
    ++ optional stdenv.isLinux linux-pam
    ++ optional (!stdenv.isDarwin) mytopEnv;

  patches = common.patches ++ [
    ./cmake-without-client.patch
  ];

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
  ] ++ stdenv.lib.optionals withoutClient [
    "-DWITHOUT_CLIENT=ON"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DWITHOUT_OQGRAPH=1"
    "-DWITHOUT_TOKUDB=1"
  ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags \
      -DCMAKE_INSTALL_PREFIX_DEV=$dev
      -DINSTALL_SHAREDIR=$dev/share/mysql
      -DINSTALL_SUPPORTFILESDIR=$dev/share/mysql"
  '' + optionalString (!stdenv.isDarwin) ''
    patchShebangs scripts/mytop.sh
  '';

  postInstall = common.postInstall + ''
    chmod +x "$out"/bin/wsrep_sst_common
    rm "$out"/bin/mysql_client_test
    rm -r "$out"/data # Don't need testing data
    rm "$out"/lib/{libmysqlclient${libExt},libmysqlclient_r${libExt}}
    mv "$out"/share/{groonga,groonga-normalizer-mysql} "$out"/share/doc/mysql
  '' + optionalString withoutClient ''
    ${ # We don't build with GSSAPI on Darwin
      optionalString (!stdenv.isDarwin) ''
        rm "$out"/lib/mysql/plugin/auth_gssapi_client.so
      ''
    }
    rm "$out"/lib/mysql/plugin/client_ed25519.so
  '' + optionalString (!stdenv.isDarwin) ''
    sed -i 's/-mariadb/-mysql/' "$out"/bin/galera_new_cluster
  '';

  # perlPackages.DBDmysql is broken on darwin
  postFixup = optionalString (!stdenv.isDarwin) ''
    wrapProgram $out/bin/mytop --set PATH ${less}/bin/less
  '';

  CXXFLAGS = optionalString stdenv.isi686 "-fpermissive";
});
in mariadb
