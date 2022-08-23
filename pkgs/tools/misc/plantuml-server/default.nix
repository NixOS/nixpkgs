{ lib, stdenv, fetchurl }:

let
  version = "1.2022.6";
in
stdenv.mkDerivation rec {
  pname = "plantuml-server";
  inherit version;
  src = fetchurl {
    url = "https://github.com/plantuml/plantuml-server/releases/download/v${version}/plantuml-v${version}.war";
    sha256 = "sha256-/dl3ZqvHcr92jhg2QDqOPCOuvpjV/9Qrw8pbsOXKZkU=";
  };

  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/plantuml.war"
  '';

  meta = with lib; {
    description = "A web application to generate UML diagrams on-the-fly.";
    homepage = "https://plantuml.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ truh ];
  };
}
