{ stdenv, fetchFromGitHub, rustPlatform, coreutils, bash, dash }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l35pri5m5k5j12zd42kr5pdx97q1xq1r0shif7hs768if0n8ihm";
  };

  cargoSha256 = "0wqjk2zxkd6lwki7blsdsbdnr250zs4d0ivjxc2w3i3xivlsjbw8";

  checkInputs = [ coreutils bash dash ];

  preCheck = ''
    # USER must not be empty
    export USER=just-user
    export USERNAME=just-user

    sed -i tests/integration.rs \
        -e "s@/bin/echo@${coreutils}/bin/echo@g" \
        -e "s@#!/usr/bin/env sh@#!${bash}/bin/sh@g" \
        -e "s@#!/usr/bin/env cat@#!${coreutils}/bin/cat@g"

    sed -i tests/interrupts.rs \
        -e "s@/bin/echo@${coreutils}/bin/echo@g" \
        -e "s@#!/usr/bin/env sh@#!${bash}/bin/sh@g" \
        -e "s@#!/usr/bin/env cat@#!${coreutils}/bin/cat@g"

    sed -i src/justfile.rs \
        -e "s@/bin/echo@${coreutils}/bin/echo@g" \
        -e "s@#!/usr/bin/env sh@#!${bash}/bin/sh@g" \
        -e "s@#!/usr/bin/env cat@#!${coreutils}/bin/cat@g"
  '';

  meta = with stdenv.lib; {
    description = "A handy way to save and run project-specific commands";
    homepage = https://github.com/casey/just;
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
