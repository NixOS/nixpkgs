{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttr: {
  pname = "iat";
  version = "0.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/iat.berlios/iat-${finalAttr.version}.tar.gz";
    hash = "sha256-sl1X/eKKArLYfNSf0UeLA5rb2DY1GHmmVP6hTCd2SyE=";
  };

  meta = with lib; {
    description = "The Iso9660 Analyzer Tool is a tool for detecting the structure of many types of CD/DVD images. It can convert from IMG to ISO format.";
    homepage = "https://www.berlios.de/software/iso9660-analyzer-tool/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hughobrien ];
    platforms = platforms.linux;
  };
})
