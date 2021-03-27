{ lib, fetchFromGitHub, rustPlatform, coreutils, bash, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D2QGlIBTso1rbirxNci+pfMhUqeA2tZr33CLEywjJcQ=";
  };

  cargoSha256 = "sha256-9B1kXV9y5VnA0UcHLbdt4zbilPvgcz/jyduob0uSFY4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/just.1

    installShellCompletion --cmd just \
      --bash completions/just.bash \
      --fish completions/just.fish \
      --zsh  completions/just.zsh
  '';

  checkInputs = [ coreutils bash ];

  preCheck = ''
    # USER must not be empty
    export USER=just-user
    export USERNAME=just-user

    sed -i src/justfile.rs \
        -i tests/*.rs \
        -e "s@/bin/echo@${coreutils}/bin/echo@g" \
        -e "s@#!/usr/bin/env sh@#!${bash}/bin/sh@g" \
        -e "s@#!/usr/bin/env cat@#!${coreutils}/bin/cat@g" \
        -e "s@#!/usr/bin/env bash@#!${bash}/bin/sh@g"
  '';

  # Skip "edit" when running "cargo test", since this test case needs "cat".
  # Skip "choose" when running "cargo test", since this test case needs "fzf".
  checkFlags = [ "--skip=choose" "--skip=edit" ];

  meta = with lib; {
    description = "A handy way to save and run project-specific commands";
    homepage = "https://github.com/casey/just";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
  };
}
