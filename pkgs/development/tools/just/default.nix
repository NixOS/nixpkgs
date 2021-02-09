{ lib, fetchFromGitHub, rustPlatform, coreutils, bash, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K8jeX1/Wn6mbf48GIR2wRAwiwg1rxtbtCPjjH+4dPYw=";
  };

  cargoSha256 = "sha256-a9SBeX3oesdoC5G+4dK2tbt+W7VA4jPqCM9tOAex4DI=";

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
