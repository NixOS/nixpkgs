{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "martin";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    rev = "v${version}";
    hash = "sha256-UIAsij4fFxGAoKluQFAtrfgKIteM+LQtAKRDvRaNLSg=";
  };

  cargoHash = "sha256-NtPI8MZNUn+QYPuG9WNMVZJW6jmyi5gEfNw8MrkiwUQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.maplibre.org/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ sikmir ];
  };
}
