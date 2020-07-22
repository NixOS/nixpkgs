{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices, rust }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "181v922nx8152ymszig1kw6y0mnix6si1zfnv6vqgr5r53pwkbc1";
  };

  cargoSha256 = "1abhzi1396x8lnxvakj34nysl3ybvsaf21j678wzaqwj16sd3w3d";

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
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ivan ];
  };
}
