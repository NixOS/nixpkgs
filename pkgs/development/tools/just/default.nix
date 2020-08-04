{ stdenv, fetchFromGitHub, rustPlatform, coreutils, bash, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "07fjixz8y5rxfwpyr1kiimnn27jhc20gacd17i0yvfcpy5qf8z5p";
  };

  cargoSha256 = "1zn0kiqi8p25lscjd661gczay631nwzadl36cfzqnbww6blayy1j";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/just.1

    installShellCompletion --bash --name just.bash completions/just.bash
    installShellCompletion --fish --name just.fish completions/just.fish
    installShellCompletion --zsh  --name _just     completions/just.zsh
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

  # Skip "edit" when running "cargo test",
  # since this test case needs "cat".
  checkFlagsArray = [ "--skip=edit" ];

  meta = with stdenv.lib; {
    description = "A handy way to save and run project-specific commands";
    homepage = "https://github.com/casey/just";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
