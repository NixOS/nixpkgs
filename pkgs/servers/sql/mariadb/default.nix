{ stdenv, fetchurl, cmake, ncurses, openssl, bison, boost, libxml2, libaio, judy, libevent, groff }:

stdenv.mkDerivation rec {
  name = "mariadb-10.0.10";

  src = fetchurl {
    url = "https://fossies.org/linux/misc/${name}.tar.gz";
    md5 = "14ce22b8197d4eae88d237776d47220f";
  };

  buildInputs = [ cmake ncurses openssl bison boost libxml2 libaio judy libevent groff ];

  cmakeFlags = [ "-DWITH_READLINE=yes" "-DWITH_EMBEDDED_SERVER=yes" "-DWITHOUT_TOKUDB=1" "-DINSTALL_SCRIPTDIR=bin" ];

  enableParallelBuilding = true;

  passthru.mysqlVersion = "5.5";

  meta = {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = https://mariadb.org/;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
