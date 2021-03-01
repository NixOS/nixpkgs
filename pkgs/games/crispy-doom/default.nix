{ lib, stdenv, autoreconfHook, pkg-config, SDL2, SDL2_mixer, SDL2_net, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  pname = "crispy-doom";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-hRdd5ZrcVBU7tn1juvrLdbenULzu6OsXefG0oLjjFIg=";
  };

  postPatch = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
    for script in $(grep -lr '^#!/usr/bin/env python$'); do patchShebangs $script; done
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config python ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];
  enableParallelBuilding = true;

  meta = {
    homepage = "http://fabiangreffrath.github.io/crispy-doom";
    description = "A limit-removing enhanced-resolution Doom source port based on Chocolate Doom";
    longDescription = ''
      Crispy Doom is a limit-removing enhanced-resolution Doom source port based on Chocolate Doom.
      Its name means that 640x400 looks \"crisp\" and is also a slight reference to its origin.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ neonfuz ];
  };
}
