{ lib
, rustPlatform
, darwin
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "star-history";
  version = "1.0.17";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-r1mDMpnu0/xWLtfM7WsVdO8nbkqNBXvYn31hB9qzgVY=";
  };

  cargoHash = "sha256-e65WlmHfo6zIXkQ/7RqqX4wYjbATfC1ke9Zwcm+EQ7M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "star-history";
  };
}
