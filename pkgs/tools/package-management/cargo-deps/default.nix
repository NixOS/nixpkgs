{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deps";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "m-cat";
    repo = pname;
    rev = "4033018eaa53134fd6169653b709b195a5f5958b";
    sha256 = "1cdmgdag9chjifsp2hxr9j15hb6l6anqq38y8srj1nk047a3kbcw";
  };

  cargoSha256 = "1gjbvgpicy9n311qh9a5n0gdyd2rnc0b9zypnzk2ibn1pgaikafy";

  meta = with lib; {
    description = "Cargo subcommand for building dependency graphs of Rust projects";
    homepage = https://github.com/m-cat/cargo-deps;
    license = licenses.mit;
    maintainers = with maintainers; [ arcnmx ];
    platforms = platforms.all;
  };
}
