{
  lib,
  mkTclDerivation,
  fetchzip,
}:

mkTclDerivation rec {
  pname = "pdf4tcl";
  version = "0.9.4";

  src = fetchzip {
    url = "mirror://sourceforge/pdf4tcl/pdf4tcl${lib.replaceStrings [ "." ] [ "" ] version}.tar.gz";
    hash = "sha256-lmSt0UQDfUef8S7zevAvvbeWB/vd6jLbKz7Y5A7xJm4=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pdf4tcl
    cp -r * $out/lib/pdf4tcl/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tcl package for generating PDF files";
    homepage = "https://pdf4tcl.sourceforge.net/";
    license = licenses.tcltk;
    maintainers = with maintainers; [ fgaz ];
  };
}
