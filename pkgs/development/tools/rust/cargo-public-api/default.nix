{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.27.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NpOufmqaNsJeWv0I0PYRMs60rvWnUA3CrwsJ9U/t8Ps=";
  };

  cargoSha256 = "sha256-eFCqUV5P4QSvxqCjj4Esb/E0PosU5wJK31O92pRt1XA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

