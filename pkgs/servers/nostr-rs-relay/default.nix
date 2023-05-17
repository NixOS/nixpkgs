{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, libiconv
, darwin
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "nostr-rs-relay";
  version = "0.8.9";
  src = fetchFromGitHub {
    owner = "scsibug";
    repo = "nostr-rs-relay";
    rev = version;
    hash = "sha256-x5y/d76Qel8FMIlUn8NdwihWebJsNIt2it2vs/Xlk0Q=";
  };

  cargoHash = "sha256-1wgBABgcogHCk183AaTwbbSGk8d8FvlZYvw1//5y93I=";

  buildInputs = [ openssl.dev ]
    ++ lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeBuildInputs = [
    pkg-config # for openssl
    protobuf
  ];

  meta = with lib; {
    description = "Nostr relay written in Rust";
    homepage = "https://sr.ht/~gheartsfield/nostr-rs-relay/";
    changelog = "https://github.com/scsibug/nostr-rs-relay/releases/tag/${version}";
    maintainers = with maintainers; [ jurraca ];
    license = licenses.mit;
  };
}
