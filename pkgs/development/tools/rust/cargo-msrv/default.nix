{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ynv5d2rxlc1gzq93v8qjyl5063w7q42g9m95250yh2lmf9hdj5i";
  };

  cargoSha256 = "03rphdps17gzcmf8n5w14x5i5rjnfznsl150s3cz5vzhbmnlpszf";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  # Integration tests fail
  doCheck = false;

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
