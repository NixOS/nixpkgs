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
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-vVbIwYfjU3Fmqwd7H7xZNYfrZlgMNdsxPGKLCjc6Ud0=";
  };

  cargoSha256 = "sha256-uiz7SwHDL7NQroiTO2gK/WA5AS9LTQram73cAU60Lac=";

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
