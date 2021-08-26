{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, Foundation, rust, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3IgzMUCkcKUkhTb/ZNRONdvB6Ci0OBB1dcjtc65U8xE=";
  };

  cargoSha256 = "sha256-Xp/pxPKs41TXO/EUY5x8Bha7NUioMabbb73///fFr6U=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Foundation libiconv ];

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  preCheck = ''
    export PATH="$(pwd)/target/${rust.toRustTarget stdenv.hostPlatform}/release:$PATH"
  '';

  meta = with lib; {
    description = "A Cargo subcommand for watching over Cargo project's source";
    homepage = "https://github.com/passcod/cargo-watch";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ivan ];
  };
}
