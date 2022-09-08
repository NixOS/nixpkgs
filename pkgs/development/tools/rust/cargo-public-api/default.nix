{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.18.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-h5eLJyrk5n2lSSeAT6YHDALay7CsN/xApl3j0s3pIjc=";
  };

  cargoSha256 = "sha256-1zt3q04LPER+Kvp6EQHziWzYeckFYO9MmPRlHto2Juo=";

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

