{ lib, stdenv, rustPlatform, fetchFromGitHub, fetchpatch, Security }:

rustPlatform.buildRustPackage rec {
  pname = "martin";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    rev = "v${version}";
    hash = "sha256-+XD4w6W6dyKuTItLQS0P/waksIVsPXVswcrCQ7jpw90=";
  };

  cargoHash = "sha256-U3oNyMS4S44ybAtt1/b0AXDLiag41XWt9DT5mKLQzm8=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.maplibre.org/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ sikmir ];
  };
}
