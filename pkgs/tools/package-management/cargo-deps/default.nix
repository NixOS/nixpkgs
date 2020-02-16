{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deps";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "m-cat";
    repo = pname;
    rev = "ab93f5655900e49fb0360ccaf72b2b61b6b428ef";
    sha256 = "16181p7ghvy9mqippg1xi2cw7yxvicis8v6n39wly5qw05i57aw2";
  };

  cargoSha256 = "1zk6pf7agqs1mpld40rn05cwp4wy0vpjnn5ip6m83bxm8b3i87wk";

  meta = with lib; {
    description = "Cargo subcommand for building dependency graphs of Rust projects";
    homepage = https://github.com/m-cat/cargo-deps;
    license = licenses.mit;
    maintainers = with maintainers; [ arcnmx ];
    platforms = platforms.all;
  };
}
