{ stdenv, fetchurl, cmake, pkgconfig, ncurses, zlib, xz, lzo, lz4, bzip2, snappy
, libiconv, openssl, pcre, boost, judy, bison, libxml2
, libaio, libevent, groff, jemalloc, cracklib, systemd, numactl, perl
, fixDarwinDylibNames, cctools, CoreServices
}:

with stdenv.lib;

let # in mariadb # spans the whole file

mariadb = everything // {
  inherit client; # libmysqlclient.so in .out, necessary headers in .dev and utils in .bin
  server = everything; # a full single-output build, including everything in `client` again
  inherit connector-c; # libmysqlclient.so
};

common = rec { # attributes common to both builds
  version = "10.2.12";

  src = fetchurl {
    url    = "https://downloads.mariadb.org/f/mariadb-${version}/source/mariadb-${version}.tar.gz";
    sha256 = "1v21sc1y5qndwdbr921da1s009bkn6pshwcgw47w7aygp9zjvcia";
    name   = "mariadb-${version}.tar.gz";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    ncurses openssl zlib pcre jemalloc libiconv
  ] ++ stdenv.lib.optionals stdenv.isLinux [ libaio systemd ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ perl fixDarwinDylibNames cctools CoreServices ];

  prePatch = ''
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '';

  patches = [ ./cmake-includedir.patch ]
    ++ stdenv.lib.optional stdenv.cc.isClang ./clang-isfinite.patch;

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

    # On Darwin without sandbox, CMake will find the system java and attempt to build with java support, but
    # then it will fail during the actual build. Let's just disable the flag explicitly until someone decides
    # to pass in java explicitly. This should have no effect on Linux.
    "-DCONNECT_WITH_JDBC=OFF"

    # Same as above. Somehow on Darwin CMake decides that we support GSS even though we aren't provding the
    # library through Nix, and then breaks later on. This should have no effect on Linux.
    "-DPLUGIN_AUTH_GSSAPI=NO"
    "-DPLUGIN_AUTH_GSSAPI_CLIENT=NO"
  ]
    ++ optional stdenv.isDarwin "-DCURSES_LIBRARY=${ncurses.out}/lib/libncurses.dylib"
    ++ optional stdenv.hostPlatform.isMusl "-DWITHOUT_TOKUDB=1" # mariadb docs say disable this for musl
    ;

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DINSTALL_INCLUDEDIR=''${!outputDev}/include/mysql"
  '';

  postInstall = ''
    rm "$out"/lib/*.a
    find "''${!outputBin}/bin" -name '*test*' -delete
  '';

  passthru.mysqlVersion = "5.7";

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

  outputs = [ "bin" "dev" "out" ];

  propagatedBuildInputs = [ openssl zlib ]; # required from mariadb.pc

  cmakeFlags = common.cmakeFlags ++ [
    "-DWITHOUT_SERVER=ON"
  ];

  preConfigure = common.preConfigure + ''
    cmakeFlags="$cmakeFlags \
      -DINSTALL_BINDIR=$bin/bin \
      -DINSTALL_SCRIPTDIR=$bin/bin \
      -DINSTALL_SUPPORTFILESDIR=$bin/share/mysql \
      -DINSTALL_DOCDIR=$bin/share/doc/mysql \
      -DINSTALL_DOCREADMEDIR=$bin/share/doc/mysql \
      "
  '';

  # prevent cycle; it needs to reference $dev
  postInstall = common.postInstall + ''
    moveToOutput bin/mysql_config "$dev"
    moveToOutput bin/mariadb_config "$dev"
  '';

  enableParallelBuilding = true; # the client should be OK
});

everything = stdenv.mkDerivation (common // {
  name = "mariadb-${common.version}";

  nativeBuildInputs = common.nativeBuildInputs ++ [ bison ];

  buildInputs = common.buildInputs ++ [
    xz lzo lz4 bzip2 snappy
    libxml2 boost judy libevent cracklib
  ] ++ optional (stdenv.isLinux && !stdenv.isArm) numactl;

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
    "-DINSTALL_MYSQLTESTDIR=OFF"
    "-DINSTALL_SQLBENCHDIR=OFF"

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
    rm -r "$out"/data # Don't need testing data
    rm "$out"/share/man/man1/mysql-test-run.pl.1
    rm "$out"/bin/rcmysql
  '';

  CXXFLAGS = optionalString stdenv.isi686 "-fpermissive"
    + optionalString stdenv.isDarwin " -std=c++11";
});

connector-c = stdenv.mkDerivation rec {
  name = "mariadb-connector-c-${version}";
  version = "2.3.4";

  src = fetchurl {
    url = "https://downloads.mariadb.org/interstitial/connector-c-${version}/mariadb-connector-c-${version}-src.tar.gz/from/http%3A//ftp.hosteurope.de/mirror/archive.mariadb.org/?serve";
    sha256 = "1g1sq5knarxkfhpkcczr6qxmq12pid65cdkqnhnfs94av89hbswb";
    name   = "mariadb-connector-c-${version}-src.tar.gz";
  };

  # outputs = [ "dev" "out" ]; FIXME: cmake variables don't allow that < 3.0
  cmakeFlags = [
    "-DWITH_EXTERNAL_ZLIB=ON"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
  ];

  # The cmake setup-hook uses $out/lib by default, this is not the case here.
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    cmakeFlagsArray+=("-DCMAKE_INSTALL_NAME_DIR=$out/lib/mariadb")
  '';

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ openssl zlib ];
  buildInputs = [ libiconv ];

  enableParallelBuilding = true;

  postFixup = ''
    ln -sv mariadb_config $out/bin/mysql_config
    ln -sv mariadb $out/lib/mysql
    ln -sv mariadb $out/include/mysql
  '';

  meta = with stdenv.lib; {
    description = "Client library that can be used to connect to MySQL or MariaDB";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.all;
  };
};

in mariadb
