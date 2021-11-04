{ lib, stdenv, fetchurl, cmake, curl, boost, bison, ncurses, libaio
, pkg-config, openssl, readline, zlib, perl, libtirpc, rpcsvc-proto }:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation rec {
  pname = "percona";
  version = "5.7.33-36";

  src = fetchurl {
    url = "https://www.percona.com/downloads/Percona-Server-5.7/Percona-Server-${version}/source/tarball/percona-server-${version}.tar.gz";
    sha256 = "0nzxxmdm9zl57rnaxnfbyf79srcy9z9d50dy4qg44dg2l7s34kln";
  };

  preConfigure = lib.optional stdenv.isDarwin ''
    ln -s /bin/ps $TMPDIR/ps
    export PATH=$PATH:$TMPDIR
  '';

  nativeBuildInputs = [ bison cmake pkg-config ]
    ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ];

  buildInputs = [
      curl ncurses openssl readline zlib boost libaio libtirpc
    ] ++ lib.optional stdenv.isDarwin perl;

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # To run libmysql/libmysql_api_test during build.
    "-DBUILD_CONFIG=mysql_release"
    "-DWITH_SSL=system"
    "-DWITH_EMBEDDED_SERVER=no"
    "-DWITH_ZLIB=system"
    "-DWITH_EDITLINE=bundled"
    "-DHAVE_IPV6=yes"
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
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

  prePatch = ''
    sed -i -e "s|/usr/bin/libtool|libtool|" cmake/libutils.cmake

    patchShebangs .

    sed -i "s|COMMAND env -i |COMMAND env -i PATH=$PATH |" \
      storage/rocksdb/CMakeLists.txt

    # Disable ABI check. See case #108154
    sed -i "s/SET(RUN_ABI_CHECK 1)/SET(RUN_ABI_CHECK 0)/" cmake/abi_check.cmake

  '';
  postInstall = ''
    sed -i -e "s|basedir=\"\"|basedir=\"$out\"|" $out/bin/mysql_install_db
    rm -r $out/mysql-test $out/lib/*.a
  '';

  preBuild = ''
    export LD_LIBRARY_PATH=$(pwd)/library_output_directory
  '';

  passthru.mysqlVersion = "5.7";

  meta = with lib; {
    homepage = "https://www.percona.com";
    description = "a free, fully compatible, enhanced, open source drop-in replacement for MySQL that provides superior performance, scalability and instrumentation";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
