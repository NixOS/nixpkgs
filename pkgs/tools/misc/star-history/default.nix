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
  version = "1.0.20";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1mAEDcg25v47zKSYbL0w6KX56ZIti6NcpnQKUyrtybg=";
  };

  cargoHash = "sha256-qkIHNFCGLtQ1uO0Y3vKR3zBtKj8Cq0ptgQcqeGvG5qs=";

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
