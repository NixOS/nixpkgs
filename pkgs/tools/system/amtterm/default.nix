{
  fetchurl,
  lib,
  stdenv,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amtterm";
  version = "1.7-1";

  buildInputs = with perlPackages; [
    perl
    SOAPLite
  ];
  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "https://www.kraxel.org/cgit/amtterm/snapshot/amtterm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-WrYWAXLW74hb/DfSiPyiFIGAUfDQFdNEPx+XevZYcyk=";
  };

  makeFlags = [
    "prefix=$(out)"
    "STRIP="
  ];

  postInstall = "wrapProgram $out/bin/amttool --prefix PERL5LIB : $PERL5LIB";

  meta = with lib; {
    description = "Intel AMT® SoL client + tools";
    homepage = "https://www.kraxel.org/cgit/amtterm/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
})
