{ lib, fetchFromGitHub, stdenv, rustPlatform, coreutils, bash, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5W/5HgXjDmr2JGYGy5FPmCNIuAagmzEHnskDUg+FzjY=";
  };

  cargoSha256 = "sha256-4lLWtj/MLaSZU7nC4gVn7TyhaLtO1FUSinQejocpiuY=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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

    # Prevent string.rs from being changed
    cp tests/string.rs $TMPDIR/string.rs

    sed -i src/justfile.rs \
        -i tests/*.rs \
        -e "s@/bin/echo@${coreutils}/bin/echo@g" \
        -e "s@#!/usr/bin/env sh@#!${bash}/bin/sh@g" \
        -e "s@#!/usr/bin/env cat@#!${coreutils}/bin/cat@g" \
        -e "s@#!/usr/bin/env bash@#!${bash}/bin/sh@g"

    # Return unchanged string.rs
    cp $TMPDIR/string.rs tests/string.rs
  '';

  # Skip "edit" when running "cargo test", since this test case needs "cat" and "vim".
  # Skip "choose" when running "cargo test", since this test case needs "fzf".
  checkFlags = [ "--skip=choose" "--skip=edit" ];

  meta = with lib; {
    description = "A handy way to save and run project-specific commands";
    homepage = "https://github.com/casey/just";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
  };
}
