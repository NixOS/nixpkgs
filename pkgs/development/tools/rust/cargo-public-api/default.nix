{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.15.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3DBpvsjreBJz6NPHJsPV3dK+PvAvdwz7/gp9p/zBieI=";
  };

  cargoSha256 = "sha256-sP3oMphy+jbs8NUqyvanWHyDtEoFaUVQHKeTbOLfTH0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

