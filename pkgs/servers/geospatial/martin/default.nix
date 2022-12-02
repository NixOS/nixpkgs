{ lib, stdenv, rustPlatform, fetchFromGitHub, fetchpatch, Security }:

rustPlatform.buildRustPackage rec {
  pname = "martin";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    rev = "v${version}";
    hash = "sha256-k5PekD+7cmsRa7qRAqQ1gKaX7i07whKTgeU6OM39BBE=";
  };

  cargoHash = "sha256-rcyR1/b9Ap6mQR9yFDdsDJSvGxVNQrpt+t3sRSV4oPU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.maplibre.org/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ sikmir ];
  };
}
