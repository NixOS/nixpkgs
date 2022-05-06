{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.20.5";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-3UuDo6lW+SG4XhqEKvpe/JeJXwEeYTA0i65yJAjDVHk=";
  };

  cargoSha256 = "sha256-/3gh3NdIuWl0xtbLahNRGBl/BGpVUmR7sHUIX3bttpQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/sunng87/cargo-release";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gerschtli ];
  };
}
