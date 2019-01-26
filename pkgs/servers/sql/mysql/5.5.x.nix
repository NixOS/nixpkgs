{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl
, cctools, CoreServices }:

# Note: zlib is not required; MySQL can use an internal zlib.

let
self = stdenv.mkDerivation rec {
  name = "mysql-${version}";
  version = "5.5.62";

  src = fetchurl {
    url = "mirror://mysql/MySQL-5.5/${name}.tar.gz";
    sha256 = "1mwrzwk9ap09s430fpdkyhvx5j2syd3xj2hyfzvanjphq4xqbrxi";
  };

  patches = if stdenv.isCygwin then [
    ./5.5.17-cygwin.patch
    ./5.5.17-export-symbols.patch
  ] else null;

  preConfigure = stdenv.lib.optional stdenv.isDarwin ''
    ln -s /bin/ps $TMPDIR/ps
    export PATH=$PATH:$TMPDIR
  '';

  buildInputs = [ cmake bison ncurses openssl readline zlib ]
     ++ stdenv.lib.optionals stdenv.isDarwin [ perl cctools CoreServices ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DWITH_SSL=yes"
    "-DWITH_READLINE=yes"
    "-DWITH_EMBEDDED_SERVER=yes"
    "-DWITH_ZLIB=yes"
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
    "-DINSTALL_MYSQLTESTDIR="
    "-DINSTALL_SQLBENCHDIR="
  ];

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ]; # since gcc-7
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  prePatch = ''
    sed -i -e "s|/usr/bin/libtool|libtool|" cmake/libutils.cmake
  '';
  postInstall = ''
    sed -i -e "s|basedir=\"\"|basedir=\"$out\"|" $out/bin/mysql_install_db
    rm -r $out/data "$out"/lib/*.a
  '';

  passthru = {
    client = self;
    connector-c = self;
    server = self;
    mysqlVersion = "5.5";
  };

  meta = with stdenv.lib; {
    homepage = https://www.mysql.com/;
    description = "The world's most popular open source database";
    platforms = platforms.unix;
    # See https://downloads.mysql.com/docs/licenses/mysqld-5.5-gpl-en.pdf
    license = with licenses; [
      artistic1 bsd0 bsd2 bsd3 bsdOriginal
      gpl2 lgpl2 lgpl21 mit publicDomain  licenses.zlib
    ];
    broken = stdenv.isAarch64;
  };
}; in self
