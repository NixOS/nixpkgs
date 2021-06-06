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

  cargoSha256 = "15pf4x2aw8sl65g63cz4yv9y78yc2wi25h9khpqx6i7gyd7dxbsc";

  meta = with lib; {
    description = "Cargo subcommand for building dependency graphs of Rust projects";
    homepage = "https://github.com/m-cat/cargo-deps";
    license = licenses.mit;
    maintainers = with maintainers; [ arcnmx ];
  };
}
