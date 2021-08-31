{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, pkg-config
, openssl
, stdenv
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TqrbkTij+XCousADorrzsVVNVYOUEyl5+nhMn4IgaIY=";
  };

  cargoSha256 = "sha256-cA4a7lqzOXkNZ7ehM/gCqtTyAaY2TH+23bITHBId8wQ=";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  # Integration tests fail
  doCheck = false;

  buildInputs = if stdenv.isDarwin
    then [ libiconv Security ]
    else [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
