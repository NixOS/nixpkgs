{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
, curl
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-11u6y4w7Ah4SNgfNeVpanIZ5bWz1K0TkMGCxDtomKMM=";
  };

  cargoSha256 = "sha256-oXTuLWH8nSH1XZ+Zwu2jEi3yY+0SeR+N/b0s5gKVORQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security curl ];

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/sunng87/cargo-release";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gerschtli ];
  };
}
