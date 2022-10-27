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
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-GKjEp0KX/YcEWo2ci6CwTpouPYHTymDx4hk3zO5pEcU=";
  };

  cargoSha256 = "sha256-1iRHpEZ+FlZbc5SgovCYf5X1NTt4q+gigcX0sBwKM3s=";

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
