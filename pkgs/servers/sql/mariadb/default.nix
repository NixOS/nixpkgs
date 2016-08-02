{ stdenv, fetchurl, cmake, pkgconfig, ncurses, zlib, xz, lzo, lz4, bzip2, snappy
, openssl, pcre, boost, judy, bison, libxml2
, libaio, libevent, groff, jemalloc, cracklib, systemd, numactl, perl
, fixDarwinDylibNames, cctools, CoreServices
}:

with stdenv.lib;

let # in mariadb # spans the whole file

mariadb = {
  inherit client  # libmysqlclient.so in .out, necessary headers in .dev and utils in .bin
    server;       # currently a full build, including everything in `client` again
  lib = client;   # compat. with the old mariadb split
};


common = rec { # attributes common to both builds
  version = "10.1.16";

  src = fetchurl {
    url    = "https://downloads.mariadb.org/interstitial/mariadb-${version}/source/mariadb-${version}.tar.gz";
    sha256 = "14s3wq1c25n62n75hkixl8n7cni4m73w055nsx4czm655k33bjv7";
  };

  prePatch = ''
    substituteInPlace cmake/libutils.cmake \
      --replace /usr/bin/libtool libtool
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '';

  patches = stdenv.lib.optional stdenv.isDarwin ./my_context_asm.patch;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    ncurses openssl zlib pcre
  ] ++ stdenv.lib.optionals stdenv.isLinux [ jemalloc libaio systemd ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ perl fixDarwinDylibNames cctools CoreServices ];

  cmakeFlags = [
    "-DBUILD_CONFIG=mysql_release"
    "-DMANUFACTURER=NixOS.org"
    "-DDEFAULT_CHARSET=utf8"
    "-DDEFAULT_COLLATION=utf8_general_ci"
    "-DSECURITY_HARDENED=ON"

    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"

    "-DWITH_ZLIB=system"
    "-DWITH_SSL=system"
    "-DWITH_PCRE=system"
  ]
    ++ optional stdenv.isDarwin "-DCURSES_LIBRARY=${ncurses.out}/lib/libncurses.dylib"
    ;

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DINSTALL_INCLUDEDIR=''${!outputDev}/include/mysql"
  '';

  postInstall = ''
    rm "$out"/lib/*.a
    find "''${!outputBin}/bin" -name '*test*' -delete
  '';

  passthru.mysqlVersion = "5.6";

  meta = with stdenv.lib; {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = https://mariadb.org/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ thoughtpolice wkennington ];
    platforms   = platforms.all;
  };
};


client = stdenv.mkDerivation (common // {
  name = "mariadb-client-${common.version}";

  outputs = [ "dev" "out" "bin" ];

  propagatedBuildInputs = [ openssl zlib ]; # required from mariadb.pc

  cmakeFlags = common.cmakeFlags ++ [
    "-DWITHOUT_SERVER=ON"
  ];

  preConfigure = common.preConfigure + ''
    cmakeFlags="$cmakeFlags \
      -DINSTALL_BINDIR=$bin/bin -DINSTALL_SCRIPTDIR=$bin/bin \
      -DINSTALL_SUPPORTFILESDIR=$bin/share/mysql \
      -DINSTALL_DOCDIR=$bin/share/doc/mysql -DINSTALL_DOCREADMEDIR=$bin/share/doc/mysql \
      "
  '';

  # prevent cycle; it needs to reference $dev
  postInstall = common.postInstall + ''
    moveToOutput bin/mysql_config "$dev"
  '';

  enableParallelBuilding = true; # the client should be OK
});


server = stdenv.mkDerivation (common // {
  name = "mariadb-${common.version}";

  nativeBuildInputs = common.nativeBuildInputs ++ [ bison ];

  buildInputs = common.buildInputs ++ [
    xz lzo lz4 bzip2 snappy
    libxml2 boost judy libevent cracklib
  ]
    ++ optionals (stdenv.isLinux && !stdenv.isArm) [ numactl ]
    ;

  cmakeFlags = common.cmakeFlags ++ [
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DINSTALL_SYSCONFDIR=etc/mysql"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DINSTALL_SCRIPTDIR=bin"
    "-DINSTALL_SUPPORTFILESDIR=share/mysql"
    "-DINSTALL_DOCREADMEDIR=share/doc/mysql"
    "-DINSTALL_DOCDIR=share/doc/mysql"
    "-DINSTALL_SHAREDIR=share/mysql"

    "-DENABLED_LOCAL_INFILE=ON"
    "-DWITH_READLINE=ON"
    "-DWITH_EXTRA_CHARSETS=complex"
    "-DWITH_EMBEDDED_SERVER=ON"
    "-DWITH_ARCHIVE_STORAGE_ENGINE=1"
    "-DWITH_BLACKHOLE_STORAGE_ENGINE=1"
    "-DWITH_INNOBASE_STORAGE_ENGINE=1"
    "-DWITH_PARTITION_STORAGE_ENGINE=1"
    "-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1"
    "-DWITHOUT_FEDERATED_STORAGE_ENGINE=1"
    "-DWITH_WSREP=ON"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DWITHOUT_OQGRAPH_STORAGE_ENGINE=1"
    "-DWITHOUT_TOKUDB=1"
  ];

  postInstall = common.postInstall + ''
    rm -r "$out"/{mysql-test,sql-bench,data} # Don't need testing data
    rm "$out"/share/man/man1/mysql-test-run.pl.1
  '';
});

in mariadb

