{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.47.3";

  src = fetchurl {
    url = "https://gentoo.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0m4npba50sf5s61g5z3xd2r7937zwja941f2h3f081xi24c2hfck";
  };

  makeFlags = [ "INSTALL_DIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = https://gentoo.com/di/;
    license = licenses.zlib;
    updateWalker = true;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.all;
  };
}
