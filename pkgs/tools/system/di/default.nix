{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-${version}";
  version = "4.45";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "18z56rprhpm6y0s7pqs19yf7ilq7n50020qzxdm9yra77ivdr09z";
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
