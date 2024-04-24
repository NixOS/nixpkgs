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
  version = "0.8.13";
  src = fetchFromGitHub {
    owner = "scsibug";
    repo = "nostr-rs-relay";
    rev = version;
    hash = "sha256-YgYi387b1qlGpjupqgGuLx8muHJ1iMx1sH82UW3TsQg=";
  };

  cargoHash = "sha256-CwyX8VlzH/y5LZtaMDd/4yWGCZLczc9bW4AqUzQFFKU=";

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
