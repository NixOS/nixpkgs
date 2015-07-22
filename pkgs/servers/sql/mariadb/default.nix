{ stdenv, fetchurl, cmake, ncurses, zlib, bzip2, lzma, lzo, lz4, openssl, pcre
, boost, judy, bison, libxml2, libaio, libevent, groff, jemalloc, perl, readline
, libgroonga, groonga-normalizer-mysql, fixDarwinDylibNames, pkgconfig
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "mariadb-${version}";
  version = "10.0.20";

  src = fetchurl {
    url    = "https://downloads.mariadb.org/interstitial/mariadb-${version}/source/mariadb-${version}.tar.gz";
    sha256 = "0ywb730l68mxvmpik1x2ndbdaaks6dmc17pxspspm5wlqxinjkrs";
  };

  nativeBuildInputs = [ pkgconfig bison cmake ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ perl fixDarwinDylibNames ];
  buildInputs = [
    ncurses openssl zlib bzip2 lzma lzo lz4 pcre libxml2 boost judy libevent
    readline libgroonga groonga-normalizer-mysql
  ] ++ stdenv.lib.optionals stdenv.isLinux [ jemalloc libaio ];

  patches = stdenv.lib.optional stdenv.isDarwin ./my_context_asm.patch;

  preConfigure = ''
    # Install Paths
    cmakeFlagsArray+=("-DINSTALL_BINDIR=$bin/bin")
    cmakeFlagsArray+=("-DINSTALL_SBINDIR=$bin/sbin")
    cmakeFlagsArray+=("-DINSTALL_SCRIPTDIR=$bin/bin")
    cmakeFlagsArray+=("-DINSTALL_SYSCONFDIR=/etc")
    cmakeFlagsArray+=("-DINSTALL_SYSCONF2DIR=/etc/my.cnf.d")

    cmakeFlagsArray+=("-DINSTALL_LIBDIR=$lib/lib")
    cmakeFlagsArray+=("-DINSTALL_PLUGINDIR=$lib/lib/mysql/plugin")

    cmakeFlagsArray+=("-DINSTALL_INCLUDEDIR=$dev/include/mysql")

    cmakeFlagsArray+=("-DINSTALL_DOCDIR=$doc/share/doc")
    cmakeFlagsArray+=("-DINSTALL_DOCREADMEDIR=$doc/share/doc")
    cmakeFlagsArray+=("-DINSTALL_MANDIR=$man/share/man")
    cmakeFlagsArray+=("-DINSTALL_INFODIR=$doc/share/info")

    cmakeFlagsArray+=("-DINSTALL_SHAREDIR=$data/share")
    cmakeFlagsArray+=("-DINSTALL_MYSQLSHAREDIR=$data/share/mysql")
    cmakeFlagsArray+=("-DINSTALL_SUPPORTFILESDIR=$data/share/mysql")
    cmakeFlagsArray+=("-DINSTALL_MYSQLTESTDIR=$TMPDIR")
    cmakeFlagsArray+=("-DINSTALL_SQLBENCHDIR=$TMPDIR")
  '';

  cmakeFlags = [
    # Don't use an install prefix because this breaks the install
    # since mariadb then treats all other paths as relative
    "-DCMAKE_INSTALL_PREFIX=/"

    # Other Path Options
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"

    # General Build Options
    "-DBUILD_CONFIG=mysql_release"
    "-DWITH_UNIT_TESTS=OFF"
    "-DDEFAULT_CHARSET=utf8"
    "-DDEFAULT_COLLATION=utf8_general_ci"
    "-DENABLED_LOCAL_INFILE=ON"

    # Features
    "-DWITH_READLINE=ON"
    "-DWITH_ZLIB=system"
    "-DWITH_SSL=system"
    "-DWITH_PCRE=system"
    "-DWITH_EXTRA_CHARSETS=complex"
    "-DWITH_EMBEDDED_SERVER=ON"
    "-DWITH_ARCHIVE_STORAGE_ENGINE=1"
    "-DWITH_BLACKHOLE_STORAGE_ENGINE=1"
    "-DWITH_INNOBASE_STORAGE_ENGINE=1"
    "-DWITH_PARTITION_STORAGE_ENGINE=1"
    "-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1"
    "-DWITHOUT_FEDERATED_STORAGE_ENGINE=1"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DWITHOUT_OQGRAPH_STORAGE_ENGINE=1"
    "-DWITHOUT_TOKUDB=1"
  ];

  enableParallelBuilding = true;

  outputs = [ "out" "bin" "dev" "lib" "data" "man" "doc" ];

  prePatch = ''
    substituteInPlace cmake/libutils.cmake \
      --replace /usr/bin/libtool libtool

    # We are providing our own version of groonga so don't build the bundled version
    rm -r storage/mroonga/vendor

    # We need to override these SET calls because they hardcode paths within DEFAULT_MYSQL_HOME
    sed -i "s,SET(DEFAULT_MYSQL_HOME.*$,SET(DEFAULT_MYSQL_HOME \"$data\"),g" CMakeLists.txt
    sed -i "s,SET(SHAREDIR.*$,SET(SHAREDIR \"\''${INSTALL_MYSQLSHAREDIR}\"),g" CMakeLists.txt
    sed -i "s,SET(PLUGINDIR.*$,SET(PLUGINDIR \"\''${INSTALL_PLUGINDIR}\"),g" CMakeLists.txt

    # Don't install data files, this breaks the build as it tries to install in /data
    sed -i '/INSTALL.*DESTINATION data/d' sql/CMakeLists.txt

    # Install all of the etc files to $doc/etc instead of /etc
    sed -e "s,\''${INSTALL_SYSCONF,$doc/\0,g" \
      -i support-files/CMakeLists.txt \
      -i storage/tokudb/CMakeLists.txt
  '';

  preInstall = ''
    # Create output directories that mariadb doesn't
    mkdir -p $bin/{bin,sbin}
  '';

  postInstall = ''
    substituteInPlace $bin/bin/mysql_install_db \
      --replace basedir=\"\" basedir=\"$bin\"

    # Remove superfluous files
    rm $bin/sbin/rcmysql # Not needed with nixos units
    rm $bin/bin/mysqlbug # Encodes a path to gcc and not really useful
    rm -r $doc/etc/{logrotate,init}.d

    # Move some helper scripts into bin
    mv $data/share/mysql/mysql{-log-rotate,.server} $bin/bin
    rm $data/share/mysql/{binary-configure,mysqld_multi.server}

    # Add mysql_config to dev since configure scripts use it
    mkdir -p $dev/bin
    mv $bin/bin/mysql_config $dev/bin
    sed -i "/\(execdir\|bindir\)/ s,'[^\"']*',$dev/bin,g" $dev/bin/mysql_config

    # Make dev propagate libs so that linking works
    mkdir -p $dev/nix-support
    echo "$lib" >> $dev/nix-support/propagated-native-build-inputs

    # We expect to be storing nothing in out
    # rmdir should therefore succeed
    if ! rmdir $out; then
      echo "$out unexpected contained files"
      exit 1
    fi

    # Out needs to propagate the expected installed files
    mkdir -p $out/nix-support
    echo "$bin" >> $out/nix-support/propagated-native-build-inputs
    echo "$man" >> $out/nix-support/propagated-native-build-inputs
  '';

  preFixup = ''
    # Fix the mysql_config link time library options
    sed \
      -e 's,-lz,-L${zlib}/lib -lz,g' \
      -e 's,-lssl,-L${openssl}/lib -lssl,g' \
      -i $dev/bin/mysql_config
  '';

  postFixup = ''
    # Make sure there are no extraneous references
    check_references () {
      if grep -qr "$1" "$2"; then
        echo "Extraneous $1 in $2" >&2
        exit 1
      fi
    }

    check_references "$dev" "$out"
    check_references "$doc" "$out"

    check_references "$out" "$bin"
    check_references "$dev" "$bin"
    check_references "$man" "$bin"
    check_references "$doc" "$bin"

    check_references "$out" "$dev"
    check_references "$bin" "$dev"
    check_references "$man" "$dev"
    check_references "$doc" "$dev"

    check_references "$out" "$lib"
    check_references "$bin" "$lib"
    check_references "$dev" "$lib"
    check_references "$man" "$lib"
    check_references "$doc" "$lib"

    check_references "$out" "$data"
    check_references "$bin" "$data"
    check_references "$dev" "$data"
    check_references "$lib" "$data"
    check_references "$man" "$data"
    check_references "$doc" "$data"

    check_references "$out" "$man"
    check_references "$bin" "$man"
    check_references "$dev" "$man"
    check_references "$lib" "$man"
    check_references "$data" "$man"
    check_references "$doc" "$man"

    check_references "$out" "$doc"
    check_references "$dev" "$doc"
    check_references "$man" "$doc"
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
