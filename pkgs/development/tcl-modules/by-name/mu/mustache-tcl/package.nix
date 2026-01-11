{
  lib,
  fetchFromGitHub,
  mkTclDerivation,
  tcllib,
}:

mkTclDerivation rec {
  pname = "mustache-tcl";
  version = "1.1.3.4";

  src = fetchFromGitHub {
    owner = "ianka";
    repo = "mustache.tcl";
    tag = "v${version}";
    hash = "sha256-apM57LEZ0Y9hXcEPWrKYOoTVtP5QSqiaQrjTHQc3pc4=";
  };

  buildInputs = [
    tcllib
  ];

  unpackPhase = ''
    mkdir -p $out/lib/mustache-tcl
    cp $src/mustache.tcl $out/lib/mustache-tcl/mustache.tcl
    cp $src/pkgIndex.tcl $out/lib/mustache-tcl/pkgIndex.tcl
  '';

  meta = {
    homepage = "https://github.com/ianka/mustache.tcl";
    description = "Tcl implementation of the mustache templating language";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ nat-418 ];
  };
}
