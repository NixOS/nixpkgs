{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "sha256-MPky0ZB7yfl/gOPThx1BpRoTgvY7mkLaoqnvGKPvSPo=";
  };

  cargoSha256 = "sha256-reVw8YkKi+EMDk0Bva2Ugp72VhAYB6axHonkr9Kdos4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage man/man1/shadowenv.1
    installManPage man/man5/shadowlisp.5
    installShellCompletion --bash sh/completions/shadowenv.bash
    installShellCompletion --fish sh/completions/shadowenv.fish
    installShellCompletion --zsh sh/completions/_shadowenv
  '';

  meta = with lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
