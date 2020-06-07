{ stdenv, lib, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "passcod";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yg6im7hzwzl84gxcg7wbix5h0ciq4l4ql6ili7k0k7j8bhrxn82";
  };

  cargoSha256 = "1y299mvg9k568f16d2r92y0bgwfrng6idw21wcsd5mnsd28fsww1";

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
