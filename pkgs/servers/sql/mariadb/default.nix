{ stdenv, fetchurl, cmake, ncurses, openssl, bison, boost, libxml2, libaio, judy, libevent, groff }:

stdenv.mkDerivation rec {
  name = "mariadb-10.0.8";

  src = fetchurl {
    url = "http://tweedo.com/mirror/mariadb/${name}/kvm-tarbake-jaunty-x86/${name}.tar.gz";
    md5 = "2b925d0beae8101f1f3f98102da91bf7";
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
