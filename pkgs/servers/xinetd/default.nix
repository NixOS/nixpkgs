{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "xinetd-2.3.15";

  src = fetchurl {
    url = "http://www.xinetd.org/${name}.tar.gz";
    sha256 = "1qsv1al506x33gh92bqa8w21k7mxqrbsrwmxvkj0amn72420ckmz";
  };

  meta = {
    description = "Secure replacement for inetd";
    platforms = stdenv.lib.platforms.linux;
    homepage = http://xinetd.org;
    license = "free";
  };
}
