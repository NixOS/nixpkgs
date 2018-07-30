{ stdenv, fetchurl, cmake, pkgconfig, ncurses, zlib, xz, lzo, lz4, bzip2, snappy
, libiconv, openssl, pcre, boost, judy, bison, libxml2, libkrb5
, libaio, libevent, jemalloc, cracklib, systemd, numactl, perl
, fixDarwinDylibNames, cctools, CoreServices
, asio, buildEnv, check, scons
}:

with stdenv.lib;

let # in mariadb # spans the whole file

mariadb = everything // {
  inherit client; # libmysqlclient.so in .out, necessary headers in .dev and utils in .bin
  server = everything; # a full single-output build, including everything in `client` again
  inherit connector-c; # libmysqlclient.so
  inherit galera;
};

galeraLibs = buildEnv {
  name = "galera-lib-inputs-united";
  paths = [ openssl.out boost check ];
};

common = rec { # attributes common to both builds
  version = "10.3.8";

  src = fetchurl {
    urls = [
      "https://downloads.mariadb.org/f/mariadb-${version}/source/mariadb-${version}.tar.gz"
      "https://downloads.mariadb.com/MariaDB/mariadb-${version}/source/mariadb-${version}.tar.gz"
    ];
    sha256 = "1f0syfrv0my7sm8cbpic00ldy90psimy8yvm0ld82bfi2isw3gih";
    name   = "mariadb-${version}.tar.gz";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    ncurses openssl zlib pcre jemalloc libiconv
  ] ++ stdenv.lib.optionals stdenv.isLinux [ libaio systemd libkrb5 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ perl fixDarwinDylibNames cctools CoreServices ];

  prePatch = ''
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
   '';

  patches = [ ./cmake-includedir.patch ./include-dirs-path.patch ]
    ++ stdenv.lib.optional stdenv.cc.isClang ./clang-isfinite.patch;

  cmakeFlags = [
    "-DBUILD_CONFIG=mysql_release"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DMANUFACTURER=NixOS.org"
    "-DDEFAULT_CHARSET=utf8mb4"
    "-DDEFAULT_COLLATION=utf8mb4_unicode_ci"
    "-DSECURITY_HARDENED=ON"
    "-DINSTALL_BINDIR=bin"
    "-DINSTALL_DOCDIR=share/doc/mysql"
    "-DINSTALL_DOCREADMEDIR=share/doc/mysql"
    "-DINSTALL_INCLUDEDIR=include/mysql"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
    "-DINSTALL_SCRIPTDIR=bin"
    "-DINSTALL_SUPPORTFILESDIR=share/doc/mysql"
    "-DINSTALL_UNIX_ADDRDIR=/run/mysqld/mysqld.sock"
    "-DINSTALL_MYSQLTESTDIR=OFF"
    "-DINSTALL_SQLBENCHDIR=OFF"
    "-DWITH_ZLIB=system"
    "-DWITH_SSL=system"
    "-DWITH_PCRE=system"
    "-DWITH_SAFEMALLOC=OFF"
    "-DEMBEDDED_LIBRARY=OFF"
  ] ++ optional stdenv.isDarwin [
    "-DCONNECT_WITH_JDBC=OFF"
    "-DCURSES_LIBRARY=${ncurses.out}/lib/libncurses.dylib"
  ] ++ optional stdenv.hostPlatform.isMusl "-DWITHOUT_TOKUDB=1" # mariadb docs say disable this for musl
    ;

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

  outputs = [ "dev" "out" "man" ];

  propagatedBuildInputs = [ openssl zlib ]; # required from mariadb.pc

  cmakeFlags = common.cmakeFlags ++ [
    "-DWITHOUT_SERVER=ON"
    "-DWITH_WSREP=OFF"
  ];

  preConfigure = ''
    cp -r ./include/* ./plugin/handler_socket/libhsclient/
  '';

  postInstall = ''
    rm -r "$out"/share/mysql
    rm -r "$out"/share/doc/mysql/{policy,systemd}
    rm "$out"/bin/{galera_new_cluster,galera_recovery,mariadb-service-convert,msql2mysql,my_print_defaults,mysql_convert_table_format,mysqld_safe_helper,mysql_install_db,mysql_plugin,mysql_secure_installation,mysql_setpermission,mysql_upgrade,mytop,perror,replace,resolveip,resolve_stack_dump,wsrep_sst_rsync_wan,mysql_config,mariadb_config}
    rm "$out"/share/doc/mysql/{binary-configure,magic,mysqld_multi.server,mysql-log-rotate,mysql.server,INSTALL-BINARY,README-wsrep,wsrep_notify}
    rm "$out"/lib/plugin/{daemon_example.ini,dialog.so,mysql_clear_password.so,sha256_password.so}
    mkdir -p "$dev"/lib && mv "$out"/lib/{libmariadbclient.a,libmysqlclient.a,libmysqlclient_r.a,libmysqlservices.a} "$dev"/lib
  '';

  enableParallelBuilding = true;
});

everything = stdenv.mkDerivation (common // {
  name = "mariadb-${common.version}";

  outputs = [ "dev" "out" "man" ];

  nativeBuildInputs = common.nativeBuildInputs ++ [ bison ];

  buildInputs = common.buildInputs ++ [
    xz lzo lz4 bzip2 snappy
    libxml2 boost judy libevent cracklib
  ] ++ optional (stdenv.isLinux && !stdenv.isAarch32) numactl;

  cmakeFlags = common.cmakeFlags ++ [
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DENABLED_LOCAL_INFILE=OFF"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DWITH_EMBEDDED_SERVER=OFF"
    "-DWITH_EXTRA_CHARSETS=complex"
    "-DWITH_INNODB_DISALLOW_WRITES=ON"
    "-DWITH_READLINE=ON"
    "-DWITH_UNIT_TESTS=OFF"
    "-DWITH_WSREP=ON"
    "-DWITHOUT_EXAMPLE=1"
    "-DWITHOUT_FEDERATED=1"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DWITHOUT_OQGRAPH=1"
    "-DWITHOUT_TOKUDB=1"
  ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags \
      -DINSTALL_SHAREDIR=$dev/share/mysql
      -DINSTALL_SUPPORTFILESDIR=$dev/share/mysql"
  '';

  postInstall = ''
    rm -r "$out"/data
    rm "$out"/bin/{mysql,mysql_find_rows,mysql_waitpid,mysqlaccess,mysqladmin,mysqlbinlog,mysqlcheck,mysqldump,mysqlhotcopy,mysqlimport,mysqlshow,mysqlslap,mysqltest}
    rm "$out"/lib/mysql/plugin/{auth_gssapi_client.so,client_ed25519.so,daemon_example.ini}
    mv "$out"/share/{groonga,groonga-normalizer-mysql} "$out"/share/doc/mysql
    mkdir -p "$dev"/lib && mv "$out"/lib/{libmariadbclient.a,libmysqlclient.a,libmysqlclient_r.a,libmysqlservices.a} "$dev"/lib
  '' + optionalString (! stdenv.isDarwin) ''
    sed -i 's/-mariadb/-mysql/' "$out"/bin/galera_new_cluster
  '';

  CXXFLAGS = optionalString stdenv.isi686 "-fpermissive"
    + optionalString stdenv.isDarwin " -std=c++11";
});

connector-c = stdenv.mkDerivation rec {
  name = "mariadb-connector-c-${version}";
  version = "3.0.5";

  src = fetchurl {
    url = "https://downloads.mariadb.org/interstitial/connector-c-${version}/mariadb-connector-c-${version}-src.tar.gz/from/http%3A//nyc2.mirrors.digitalocean.com/mariadb/";
    sha256 = "0rr6y04qcsgbp9mjn574if55qqf44h42jdlxxd9n310k7bqif04l";
    name   = "mariadb-connector-c-${version}-src.tar.gz";
  };

  outputs = [ "dev" "out" ];

  cmakeFlags = [
    "-DWITH_EXTERNAL_ZLIB=ON"
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
    ln -sv mariadb $dev/include/mysql
    mkdir -p "$dev"/lib/mariadb && mv "$out"/lib/mariadb/libmariadbclient.a "$dev"/lib/mariadb
  '';

  meta = with stdenv.lib; {
    description = "Client library that can be used to connect to MySQL or MariaDB";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.all;
  };
};

galera = stdenv.mkDerivation rec {
  name = "mariadb-galera-${version}";
  version = "25.3.23";

  src = fetchurl {
    url = "https://mirrors.nxthost.com/mariadb/mariadb-10.3.8/galera-${version}/src/galera-${version}.tar.gz";
    sha256 = "11pfc85z29jk0h6g6bmi3hdv4in4yb00xsr2r0qm1b0y7m2wq3ra";
  };

  buildInputs = [ asio boost check openssl scons ];

  patchPhase = ''
    substituteInPlace SConstruct \
      --replace "boost_library_path = '''" "boost_library_path = '${boost}/lib'"
  '';

  preConfigure = ''
    export CPPFLAGS="-I${asio}/include -I${boost.dev}/include -I${check}/include -I${openssl.dev}/include"
    export LIBPATH="${galeraLibs}/lib"
  '';

  buildPhase = ''
     scons -j$NIX_BUILD_CORES ssl=1 system_asio=1 strict_build_flags=0
  '';

  installPhase = ''
    # copied with modifications from scripts/packages/freebsd.sh
    GALERA_LICENSE_DIR="$share/licenses/${name}"
    install -d $out/{bin,lib/galera,share/doc/galera,$GALERA_LICENSE_DIR}
    install -m 555 "garb/garbd"                       "$out/bin/garbd"
    install -m 444 "libgalera_smm.so"                 "$out/lib/galera/libgalera_smm.so"
    install -m 444 "scripts/packages/README"          "$out/share/doc/galera/"
    install -m 444 "scripts/packages/README-MySQL"    "$out/share/doc/galera/"
    install -m 444 "scripts/packages/freebsd/LICENSE" "$out/$GALERA_LICENSE_DIR"
    install -m 444 "LICENSE"                          "$out/$GALERA_LICENSE_DIR/GPLv2"
    install -m 444 "asio/LICENSE_1_0.txt"             "$out/$GALERA_LICENSE_DIR/LICENSE.asio"
    install -m 444 "www.evanjones.ca/LICENSE"         "$out/$GALERA_LICENSE_DIR/LICENSE.crc32c"
    install -m 444 "chromium/LICENSE"                 "$out/$GALERA_LICENSE_DIR/LICENSE.chromium"
  '';

  meta = {
    description = "Galera 3 wsrep provider library";
    homepage = http://galeracluster.com/;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ izorkin ];
    platforms = platforms.all;
  };
};
in mariadb
