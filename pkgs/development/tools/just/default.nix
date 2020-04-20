{ stdenv, fetchFromGitHub, rustPlatform, coreutils, bash, dash }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s8np28glzn3kmh59dwk86yc9fb2lm9fq2325kzmy7rkb5jsdcl1";
  };

  cargoSha256 = "05mrzav3aydvwac9jjckdmlxvxnlcncmkfsdb9z7zvxia4k89w1l";

  postInstall = ''
    # generate completion scripts for just

    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}

    $out/bin/just --completions bash > "$out/share/bash-completion/completions/just"
    $out/bin/just --completions fish > "$out/share/fish/vendor_completions.d/just.fish"
    $out/bin/just --completions zsh  > "$out/share/zsh/site-functions/_just"
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
