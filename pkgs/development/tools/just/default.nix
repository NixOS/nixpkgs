{ stdenv, fetchFromGitHub, rustPlatform, coreutils, bash, dash
, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0li5lspxfrim8gymqzzd5djjfbfi7jh1m234qlzy5vkx2q9qg0xv";
  };

  cargoSha256 = "1sp8xrh3gmgmphh1bv050p1ybjybk9x8kswyxz2rd93q3zb5hpzz";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/just.1

    installShellCompletion --bash --name just.bash completions/just.bash
    installShellCompletion --fish --name just.fish completions/just.fish
    installShellCompletion --zsh  --name _just     completions/just.zsh
  '';

  checkInputs = [ coreutils bash dash ];

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

  # Skip "edit" when running "cargo test",
  # since this test case needs "cat".
  checkPhase = ''
    runHook preCheck
    echo "Running cargo test --
        --skip edit
        ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test -- \
        --skip edit \
        ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "A handy way to save and run project-specific commands";
    homepage = "https://github.com/casey/just";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
