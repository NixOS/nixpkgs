{ stdenv, fetchurl, cmake, ncurses, openssl, bison, boost, libxml2, libaio, judy, libevent, groff, perl, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  name = "mariadb-${version}";
  version = "10.0.15";

  src = fetchurl {
    url    = "https://downloads.mariadb.org/interstitial/mariadb-${version}/source/mariadb-${version}.tar.gz";
    sha256 = "1n09553brmprs9m6siwjc1ca4b9b1giqasv3mhdrnijda1lcnm4i";
  };

  buildInputs = [ cmake ncurses openssl bison boost libxml2 judy libevent groff ]
     ++ stdenv.lib.optional (!stdenv.isDarwin) libaio
     ++ stdenv.lib.optionals stdenv.isDarwin [ perl fixDarwinDylibNames ];

  patches = stdenv.lib.optional stdenv.isDarwin ./my_context_asm.patch;

  cmakeFlags = [ "-DWITH_READLINE=yes" "-DWITH_EMBEDDED_SERVER=yes" "-DINSTALL_SCRIPTDIR=bin" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  enableParallelBuilding = true;

  prePatch = ''
    substituteInPlace cmake/libutils.cmake \
      --replace /usr/bin/libtool libtool
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
  '';

  passthru.mysqlVersion = "5.5";

  meta = {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = https://mariadb.org/;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ shlevy thoughtpolice ];
    platforms   = stdenv.lib.platforms.all;
  };
}
