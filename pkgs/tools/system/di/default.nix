{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.48";

  src = fetchurl {
    url = "https://gentoo.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0crvvfsxh8ryc0j19a2x52i9zacvggm8zi6j3kzygkcwnpz4km8r";
  };

  makeFlags = [ "INSTALL_DIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = "https://gentoo.com/di/";
    license = licenses.zlib;
    updateWalker = true;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.all;
  };
}
