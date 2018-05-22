{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-${version}";
  version = "4.46";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "0cskiqywiqkw44zdg4q78bjns6jjp1dz5lzdxrhpnpldc6075irw";
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
