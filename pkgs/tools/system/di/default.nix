{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.53";

  src = fetchurl {
    url = "mirror://sourceforge/diskinfo-di/${pname}-${version}.tar.gz";
    sha256 = "sha256-AN1b78EdrI1lposkj9NBWKLmqFDC5OKrd1lMeaoB6D4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = "https://diskinfo-di.sourceforge.io/";
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.all;
  };
}
