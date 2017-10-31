{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-${version}";
  version = "4.44";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "0803lp8kd3mp1jcm17i019xiqxdy85hhs6xk67zib8gmvg500gcn";
  };

  makeFlags = [ "INSTALL_DIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = http://www.gentoo.com/di/;
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ndowens ];
    platforms = platforms.all;
  };
}
