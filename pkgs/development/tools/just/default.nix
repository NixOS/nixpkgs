{ stdenv, fetchFromGitHub, rustPlatform, coreutils, bash, dash }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "06k1pl2qmmr9q0ffw6l0dzqqfgpckmrdzjpzn9cw23shhihv99a8";
  };

  cargoSha256 = "1blsdl9dsq24vhm8cg1ja9m4b3h343lndibq6wz2kcwdq4i8jhd0";

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
