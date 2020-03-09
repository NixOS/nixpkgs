{ stdenv, fetchFromGitHub, rustPlatform, coreutils, bash, dash }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a4bml9nxvyh110a60l4lc11yr2ds5r8d3iplslccrkq1ka96av9";
  };

  cargoSha256 = "0wp61zjws9r1aapkapvq2vmad5kylkpw03wa82qhhq30knkpvr7b";

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
