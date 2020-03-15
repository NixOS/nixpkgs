{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, makeWrapper, ncurses, zlib, xz, lzo, lz4, bzip2, snappy
, libiconv, openssl, pcre, boost, judy, bison, libxml2, libkrb5, linux-pam, curl
, libaio, libevent, jemalloc, cracklib, systemd, perl
, fixDarwinDylibNames, cctools, CoreServices, less
, numactl # NUMA Support
, withStorageMroonga ? true, kytea, msgpack, zeromq
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
  version = "10.3.22";

  src = fetchurl {
    urls = [
      "https://downloads.mariadb.org/f/mariadb-${version}/source/mariadb-${version}.tar.gz"
      "https://downloads.mariadb.com/MariaDB/mariadb-${version}/source/mariadb-${version}.tar.gz"
    ];
    sha256 = "1iyf1hl82nqsci5h327a537rvdrc5qcbrd1v3fc4cxy2pmfha01j";
    name   = "mariadb-${version}.tar.gz";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    ncurses openssl zlib pcre jemalloc libiconv curl
  ] ++ optionals stdenv.hostPlatform.isLinux [ libaio systemd libkrb5 ]
    ++ optionals stdenv.hostPlatform.isDarwin [ perl fixDarwinDylibNames cctools CoreServices ];

  prePatch = ''
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '';

  patches = [
    ./cmake-includedir.patch
  ];

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
  ] ++ optionals stdenv.hostPlatform.isDarwin [
    # On Darwin without sandbox, CMake will find the system java and attempt to build with java support, but
    # then it will fail during the actual build. Let's just disable the flag explicitly until someone decides
    # to pass in java explicitly.
    "-DCONNECT_WITH_JDBC=OFF"
    "-DCURSES_LIBRARY=${ncurses.out}/lib/libncurses.dylib"
  ] ++ optionals stdenv.hostPlatform.isMusl [
    "-DWITHOUT_TOKUDB=1" # mariadb docs say disable this for musl
  ];

  postInstall = ''
    # Remove Development components. Need to use libmysqlclient.
    rm "$out"/lib/mysql/plugin/daemon_example.ini
    rm "$out"/lib/{libmariadbclient.a,libmysqlclient.a,libmysqlclient_r.a,libmysqlservices.a}
    rm "$out"/bin/{mariadb_config,mysql_config}
    rm -r $out/include
    rm -r $out/lib/pkgconfig
    rm -r $out/share/{aclocal,pkgconfig}
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

  outputs = [ "out" "man" ];

  patches = common.patches ++ [
    ./cmake-plugin-includedir.patch
    ./cmake-without-plugin-auth-pam.patch
  ];

  cmakeFlags = common.cmakeFlags ++ [
    "-DWITHOUT_SERVER=ON"
    "-DWITH_WSREP=OFF"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql-client"
  ];

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

  outputs = [ "out" "man" ];

  nativeBuildInputs = common.nativeBuildInputs ++ [ bison ] ++ optional (!stdenv.hostPlatform.isDarwin) makeWrapper;

  buildInputs = common.buildInputs ++ [
    xz lzo lz4 bzip2 snappy
    libxml2 boost judy libevent cracklib
  ] ++ optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32) numactl
    ++ optionals withStorageMroonga [ kytea msgpack zeromq ]
    ++ optional stdenv.hostPlatform.isLinux linux-pam
    ++ optional (!stdenv.hostPlatform.isDarwin) mytopEnv;

  patches = common.patches ++ optionals stdenv.hostPlatform.isDarwin [
    ./cmake-without-plugin-auth-pam.patch
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
  ] ++ optional (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32) [
    "-DWITH_NUMA=ON"
  ] ++ optional (!withStorageMroonga) [
    "-DWITHOUT_MROONGA=ON"
  ] ++ optionals stdenv.hostPlatform.isDarwin [
    "-DWITHOUT_OQGRAPH=1"
    "-DWITHOUT_TOKUDB=1"
  ];

  preConfigure = optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchShebangs scripts/mytop.sh
  '';

  postInstall = common.postInstall + ''
    chmod +x "$out"/bin/wsrep_sst_common
    rm "$out"/bin/{mysql_client_test,mysqltest}
    rm -r "$out"/data # Don't need testing data
  '' + optionalString withStorageMroonga ''
    mv "$out"/share/{groonga,groonga-normalizer-mysql} "$out"/share/doc/mysql
  '' + optionalString (!stdenv.hostPlatform.isDarwin) ''
    sed -i 's/-mariadb/-mysql/' "$out"/bin/galera_new_cluster
  '';

  # perlPackages.DBDmysql is broken on darwin
  postFixup = optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapProgram $out/bin/mytop --set PATH ${makeBinPath [ less ncurses ]}
  '';

  CXXFLAGS = optionalString stdenv.hostPlatform.isi686 "-fpermissive";
});
in mariadb
