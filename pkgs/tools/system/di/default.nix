{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-4.42";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "1i6m9zdnidn8268q1lz9fd8payk7s4pgwh5zlam9rr4dy6h6a67n";
  };

  makeFlags = [ "INSTALL_DIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = http://www.gentoo.com/di/;
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.all;
  };
}
