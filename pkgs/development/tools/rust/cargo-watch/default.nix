{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l1aalb8ans7scljrza7akhi821jbpqgn6sa8kgd8sys83r93fkj";
  };

  cargoSha256 = "07zkfpw0zyakpsm1mg525ibpsfs9swwmijb0xfsk3nbv66caqd04";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  checkPhase = "PATH=target/debug:$PATH cargo test";

  meta = with lib; {
    description = "A Cargo subcommand for watching over Cargo project's source";
    homepage = https://github.com/passcod/cargo-watch;
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ivan ];
  };
}
