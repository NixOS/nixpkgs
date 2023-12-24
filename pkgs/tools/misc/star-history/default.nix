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
  version = "1.0.16";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ChUZf8aohDOmNKPgn9+i0NNZ4rKJsXQPK6IMqWf0NQc=";
  };

  cargoHash = "sha256-RsBWmEe4D+m3hxE1ryQ5aZb2uDax519qjQoIK7xStPw=";

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
