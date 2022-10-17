{ lib, stdenv, rustPlatform, fetchFromGitHub, fetchpatch, Security }:

rustPlatform.buildRustPackage rec {
  pname = "martin";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "urbica";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kygqwbaByse81oc007piXHM6aK6Yi2JB0qTFN2WFP8U=";
  };

  cargoPatches = [
    # Remove after a new release, tracked by https://github.com/maplibre/martin/issues/410.
    ./update-socket2-for-rust-1.64.patch
  ];

  cargoHash = "sha256-oevyr1P0uzHbpWCYQ1raqA42HI2KLl2IYcm1D2PeKOo=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.urbica.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
