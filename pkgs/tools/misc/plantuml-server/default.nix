{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

let
  version = "1.2024.4";
in
stdenv.mkDerivation rec {
  pname = "plantuml-server";
  inherit version;
  src = fetchurl {
    url = "https://github.com/plantuml/plantuml-server/releases/download/v${version}/plantuml-v${version}.war";
    sha256 = "sha256-7m0MOP6AN7V7mlrVfwxGy1AfCQx2ufp5GU2WQoSTIBc=";
  };

  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/plantuml.war"
  '';

  passthru.tests = {
    inherit (nixosTests) plantuml-server;
  };

  meta = with lib; {
    description = "A web application to generate UML diagrams on-the-fly";
    homepage = "https://plantuml.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ truh ];
  };
}
