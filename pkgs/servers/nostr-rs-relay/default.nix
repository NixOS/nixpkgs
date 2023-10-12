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
  version = "0.8.12";
  src = fetchFromGitHub {
    owner = "scsibug";
    repo = "nostr-rs-relay";
    rev = version;
    hash = "sha256-3/hd3w06bILcgd7gmmpzky4Sj3exHX5xn3XGrueGDbE=";
  };

  cargoHash = "sha256-ulCUJ59LSYxzSbMBZcv2/7wDTwTGGGXoHPAZO4rudDE=";

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
