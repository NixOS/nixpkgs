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
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7GixO9aoHx07wQHTEtbEDQ52Dr3MZ0p4Xq0Ol7E/swI=";
  };

  cargoSha256 = "sha256-cxbsTRANX1WA0Lf6CHcJoxSKrGHtBfjInSKhFJmTDnE=";

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
