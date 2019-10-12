{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "13zjsypj0ay9xb5j5fhl3yfn57kp2yngl138vmnyfk1h7gjdxpk3";
  };

  cargoSha256 = "1c3h9il3y0swvcdrrqgh5r7di522i1cc8zk1kfmx97chy8bhsqvg";

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
