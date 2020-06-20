{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.4.1";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nq7sfdxvqldj94laz562y4cvgagm67b6a5b7bzxdip0sf1l11f8";
  };

  cargoSha256 = "1rjx3k8li8ck5cdygm4pd2i5wkslr6d9z9vl2vp0x6hqv1gcv5zh";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  checkPhase = "PATH=target/debug:$PATH cargo test";

  meta = with lib; {
    description = "A Cargo subcommand for watching over Cargo project's source";
    homepage = "https://github.com/passcod/cargo-watch";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ivan ];
  };
}
