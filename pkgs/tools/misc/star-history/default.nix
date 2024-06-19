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
  version = "1.0.21";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-jBeV5iZUKE70n/GTV+Bu9dy7B4pPmPhi5LHqw+YXJE0=";
  };

  cargoHash = "sha256-oHAHYNJZuD8j/VLmCwcLxv9FkfZdXnxI8cQsJ8sFmZA=";

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
