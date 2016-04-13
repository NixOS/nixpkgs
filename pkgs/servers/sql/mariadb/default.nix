{ stdenv, fetchurl, cmake, ncurses, zlib, xz, lzo, lz4, bzip2, snappy
, openssl, pcre, boost, judy, bison, libxml2
, libaio, libevent, groff, jemalloc, cracklib, systemd, numactl, perl
, fixDarwinDylibNames, cctools, CoreServices
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "mariadb-${version}";
  version = "10.1.9";

  src = fetchurl {
    url    = "https://downloads.mariadb.org/interstitial/mariadb-${version}/source/mariadb-${version}.tar.gz";
    sha256 = "0471vwg9c5c17m7679krjha16ib6d48fcsphkchb9v9cf8k5i74f";
  };

  buildInputs = [
    cmake ncurses openssl zlib xz lzo lz4 bzip2
    # temporary due to https://mariadb.atlassian.net/browse/MDEV-9000
    (if stdenv.is64bit then snappy else null)
    pcre libxml2 boost judy bison libevent cracklib
  ] ++ stdenv.lib.optionals stdenv.isLinux [ jemalloc libaio systemd numactl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ perl fixDarwinDylibNames cctools CoreServices ];

  patches = stdenv.lib.optional stdenv.isDarwin ./my_context_asm.patch;

  cmakeFlags = [
    "-DBUILD_CONFIG=mysql_release"
    "-DDEFAULT_CHARSET=utf8"
    "-DDEFAULT_COLLATION=utf8_general_ci"
    "-DENABLED_LOCAL_INFILE=ON"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DINSTALL_SYSCONFDIR=etc/mysql"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DINSTALL_SCRIPTDIR=bin"
    "-DINSTALL_INCLUDEDIR=include/mysql"
    "-DINSTALL_DOCREADMEDIR=share/mysql"
    "-DINSTALL_SUPPORTFILESDIR=share/mysql"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
    "-DINSTALL_DOCDIR=share/mysql/docs"
    "-DINSTALL_SHAREDIR=share/mysql"
    "-DWITH_READLINE=ON"
    "-DWITH_ZLIB=system"
    "-DWITH_SSL=system"
    "-DWITH_PCRE=system"
    "-DWITH_EMBEDDED_SERVER=yes"
    "-DWITH_EXTRA_CHARSETS=complex"
    "-DWITH_EMBEDDED_SERVER=ON"
    "-DWITH_ARCHIVE_STORAGE_ENGINE=1"
    "-DWITH_BLACKHOLE_STORAGE_ENGINE=1"
    "-DWITH_INNOBASE_STORAGE_ENGINE=1"
    "-DWITH_PARTITION_STORAGE_ENGINE=1"
    "-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1"
    "-DWITHOUT_FEDERATED_STORAGE_ENGINE=1"
    "-DSECURITY_HARDENED=ON"
    "-DWITH_WSREP=ON"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DWITHOUT_OQGRAPH_STORAGE_ENGINE=1"
    "-DWITHOUT_TOKUDB=1"
    "-DCURSES_LIBRARY=${ncurses}/lib/libncurses.dylib"
  ];

  # fails to find lex_token.h sometimes
  enableParallelBuilding = false;

  outputs = [ "out" "lib" ];

  prePatch = ''
    substituteInPlace cmake/libutils.cmake \
      --replace /usr/bin/libtool libtool
    sed -i "s,SET(DEFAULT_MYSQL_HOME.*$,SET(DEFAULT_MYSQL_HOME /not/a/real/dir),g" CMakeLists.txt
    sed -i "s,SET(PLUGINDIR.*$,SET(PLUGINDIR $lib/lib/mysql/plugin),g" CMakeLists.txt

    sed -i "s,SET(pkgincludedir.*$,SET(pkgincludedir $lib/include),g" scripts/CMakeLists.txt
    sed -i "s,SET(pkglibdir.*$,SET(pkglibdir $lib/lib),g" scripts/CMakeLists.txt
    sed -i "s,SET(pkgplugindir.*$,SET(pkgplugindir $lib/lib/mysql/plugin),g" scripts/CMakeLists.txt

    sed -i "s,set(libdir.*$,SET(libdir $lib/lib),g" storage/mroonga/vendor/groonga/CMakeLists.txt
    sed -i "s,set(includedir.*$,SET(includedir $lib/include),g" storage/mroonga/vendor/groonga/CMakeLists.txt
    sed -i "/\"\$[{]CMAKE_INSTALL_PREFIX}\/\$[{]GRN_RELATIVE_PLUGINS_DIR}\"/d" storage/mroonga/vendor/groonga/CMakeLists.txt
    sed -i "s,set(GRN_PLUGINS_DIR.*$,SET(GRN_PLUGINS_DIR $lib/\$\{GRN_RELATIVE_PLUGINS_DIR}),g" storage/mroonga/vendor/groonga/CMakeLists.txt
    sed -i 's,[^"]*/var/log,/var/log,g' storage/mroonga/vendor/groonga/CMakeLists.txt
  '';

  postInstall = ''
    substituteInPlace $out/bin/mysql_install_db \
      --replace basedir=\"\" basedir=\"$out\"

    # Remove superfluous files
    rm -r $out/mysql-test $out/sql-bench $out/data # Don't need testing data
    rm $out/share/man/man1/mysql-test-run.pl.1
    rm $out/bin/rcmysql # Not needed with nixos units
    rm $out/bin/mysqlbug # Encodes a path to gcc and not really useful
    find $out/bin -name \*test\* -exec rm {} \;

    # Separate libs and includes into their own derivation
    mkdir -p $lib
    mv $out/lib $lib
    mv $out/include $lib

  ''
  + stdenv.lib.optionalString stdenv.isDarwin ''
    # Fix library rpaths
    # TODO: put this in the stdenv to prepare for wide usage of multi-output derivations
    for file in $(grep -rl $out/lib $lib); do
      install_name_tool -delete_rpath $out/lib -add_rpath $lib $file
    done

  '' + ''
    # Fix the mysql_config
    sed -i $out/bin/mysql_config \
      -e 's,-lz,-L${zlib}/lib -lz,g' \
      -e 's,-lssl,-L${openssl}/lib -lssl,g'

    # Add mysql_config to libs since configure scripts use it
    mkdir -p $lib/bin
    cp $out/bin/mysql_config $lib/bin
    sed -i "/\(execdir\|bindir\)/ s,'[^\"']*',$lib/bin,g" $lib/bin/mysql_config

    # Make sure to propagate lib for compatability
    mkdir -p $out/nix-support
    echo "$lib" > $out/nix-support/propagated-native-build-inputs

    # Don't install static libraries.
    rm $lib/lib/libmysqlclient.a $lib/lib/libmysqld.a
  '';

  passthru.mysqlVersion = "5.6";

  meta = with stdenv.lib; {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = https://mariadb.org/;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice wkennington ];
    platforms   = stdenv.lib.platforms.all;
  };
}
