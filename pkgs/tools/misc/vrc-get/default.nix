{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "anatawa12";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FCLIc5c+50qGpBEbJ4bUSNAfQVdpeswNwiWrVcO91zI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async_zip-0.0.15" = "sha256-UXBVZy3nf20MUh9jQdYeS5ygrZfeRWtiNRtiyMvkdSs=";
    };
  };

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
}
