{ lib
, fetchCrate
, rustPlatform
, perl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-prebuilt";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-IbOoJ0iMlPD9hrRAT7b5mfF2ILrk1JU+J14K5kbAukU=";
  };

  cargoHash = "sha256-IPjkkrRw0brfe2YnLP3lXbduhZCwpB7zFISbuqws5hE=";

  nativeBuildInputs = [ perl ];
  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A tool to install prebuilt binaries of rust crates";
    homepage = "https://github.com/crow-rest/cargo-prebuilt";
    license = licenses.mit;
    maintainers = with maintainers; [ harmless-tech ];
  };
}
