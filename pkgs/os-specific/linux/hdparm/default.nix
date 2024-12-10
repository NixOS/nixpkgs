{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdparm";
  version = "9.65";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/hdparm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-0Ukp+RDQYJMucX6TgkJdR8LnFEI1pTcT1VqU995TWks=";
  };

  makeFlags = [
    "sbindir=${placeholder "out"}/sbin"
    "manprefix=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = "https://sourceforge.net/projects/hdparm/";
    platforms = platforms.linux;
    license = licenses.bsd2;
    mainProgram = "hdparm";
    maintainers = [ ];
  };
})
