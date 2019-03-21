{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-${version}";
  version = "4.47";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "0zlapxlzjizwzwa8xwrwibhcbkh0wx7n74gvjpp6wlwq7cgiq0xm";
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
