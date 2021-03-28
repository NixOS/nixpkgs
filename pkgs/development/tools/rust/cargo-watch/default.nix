{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, rust }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.5.1";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Eqg+Ke5n2H6/bPd1W8HL4XLMfdV8ard4SDrCeK0MFOg=";
  };

  cargoSha256 = "sha256-s7ip+/1hZJ8dQGix6yI5fQ4gAw2nHU8+dxxYcVvyTAs=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

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
