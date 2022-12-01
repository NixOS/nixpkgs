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
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-+sMlbihareVn//TaCTEMU0iDnboneRhb8FcPmY0Q04A=";
  };

  cargoSha256 = "sha256-MqS8jSjukZfD86onInFZJOtI5ntNmpb/tvwAil2rAZA=";

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
