{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, rust }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.6.1";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vjX8xfwv/DOogji+OQCB9l5ebGBNoLW722TGpZ5Wg80=";
  };

  cargoSha256 = "sha256-ku+tI0DIofV0EZ413sPjbJDUSqwTxiT8NWBeURrJW1k=";

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
