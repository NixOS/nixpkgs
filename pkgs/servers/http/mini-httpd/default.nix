{ stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  name = "mini-httpd-1.7";

  src = fetchurl {
    url = "https://download-mirror.savannah.gnu.org/releases/mini-httpd/${name}.tar.gz";
    sha256 = "0jggmlaywjfbdljzv5hyiz49plnxh0har2bnc9dq4xmj1pmjgs49";
  };

  buildInputs = [ boost ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://mini-httpd.nongnu.org/;
    description = "minimalistic high-performance web server";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
