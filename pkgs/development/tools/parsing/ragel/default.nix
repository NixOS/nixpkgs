{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fig2dev,
  texliveSmall,
  ghostscript,
  colm,
  bash,
  autoreconfHook,
  build-manual ? false,
}:

let
  generic =
    {
      version,
      src,
      dev ? false,
      broken ? false,
      license,
    }:
    stdenv.mkDerivation {
      pname = "ragel";
      inherit version src;

      buildInputs = lib.optionals (build-manual || dev) [
        fig2dev
        ghostscript
        texliveSmall
      ];

      postPatch = lib.optionalString dev ''
        find . -type f -exec sed -i 's|^#!/bin/bash|#!${lib.getExe bash}|' {} \;
      '';

      preConfigure =
        lib.optionalString (build-manual && (!dev)) ''
          sed -i "s/build_manual=no/build_manual=yes/g" DIST
        ''
        + lib.optionalString dev ''
          ./autogen.sh
        '';

      configureFlags = [ "--with-colm=${colm}" ];

      env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu++98";

      nativeBuildInputs = lib.optionals dev [ autoreconfHook ];

      doCheck = true;

      enableParallelBuilding = true;

      meta = {
        homepage = "https://www.colm.net/open-source/ragel/";
        description = "State machine compiler";
        mainProgram = "ragel";
        inherit broken license;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [ pSub ];
      };
    };

in

{
  ragelStable = generic rec {
    version = "6.10";
    src = fetchurl {
      url = "https://www.colm.net/files/ragel/ragel-${version}.tar.gz";
      hash = "sha256-XxVu22XSC4VtY43Z7i37QyhZFNmqK27HedrAJwzVbD8=";
    };
    license = lib.licenses.gpl2;
  };

  ragelDev = generic {
    version = "7.0.4-unstable-2023-03-13";
    src = fetchFromGitHub {
      owner = "adrian-thurston";
      repo = "ragel";
      rev = "65540b65ff09330b0293423e3fecc44e63f30614";
      hash = "sha256-6xo4upfjvJvA9DwM9iNF5BZ5e1jYZ49G83vQ2RTkV3E=";
    };
    dev = true;
    license = lib.licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
