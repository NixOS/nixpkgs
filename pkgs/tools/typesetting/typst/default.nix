{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "23-03-28";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
    hash = "sha256-0fTGbXdpzPadABWqdReQNZf2N7OMZ8cs9U5fmhfN6m4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iai-0.1.1" = "sha256-EdNzCPht5chg7uF9O8CtPWR/bzSYyfYIXNdLltqdlR0=";
      "lipsum-0.8.2" = "sha256-deIbpn4YM7/NeuJ5Co48ivJmxwrcsbLl6c3cP3JZxAQ=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  cargoBuildFlags = [ "-p" "typst-cli" ];
  cargoTestFlags = [ "-p" "typst-cli" ];

  # https://github.com/typst/typst/blob/056d15a/cli/src/main.rs#L164
  TYPST_VERSION = version;

  meta = with lib; {
    description = "A new markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://typst.app";
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol figsoda kanashimia ];
  };
}
