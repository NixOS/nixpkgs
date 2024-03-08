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
  version = "1.0.18";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-PKQyGDSLFRf5eEUICdtDAkbzfljdj0HN40c7+V21wHI=";
  };

  cargoHash = "sha256-LriRO5XdcTqp+7quV11RwjNQgfzQsc5EV8GNwkuwz8s=";

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
