{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.48.0.1";

  src = fetchurl {
    url = "https://gentoo.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-YFCFRDGeq2h/UXKme/NnnCuFdtw2Vim6Y3SbytaItGc=";
  };

  makeFlags = [ "INSTALL_DIR=$(out)" ];

  meta = with lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = "https://gentoo.com/di/";
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.all;
  };
}
