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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Op800CGzbSGwYvd18ba7Gvw2bVHeBHCQq1pmAMW9CUs=";
  };

  cargoSha256 = "sha256-vguDrmNYtHHR8kA6GElEx8+jVj/V853o0uW6hfg/tlI=";

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
