{ pkgs, stdenv, stdenvNoCC, gccStdenv }:

let
  callPackage = pkgs.newScope self;

  self = rec {
    dwarf-fortress-original = callPackage ./game.nix { };

    dfhack = callPackage ./dfhack {
      inherit (pkgs.perlPackages) XMLLibXML XMLLibXSLT;
      stdenv = gccStdenv;
    };

    soundSense = callPackage ./soundsense.nix { };

    # unfuck is linux-only right now, we will just use it there
    dwarf-fortress-unfuck = if stdenv.isLinux then callPackage ./unfuck.nix { }
                                              else null;

    dwarf-fortress = callPackage ./wrapper {
      themes = {
        "phoebus" = phoebus-theme;
        "cla" = cla-theme;
      };
    };

    dwarf-therapist-original = pkgs.qt5.callPackage ./dwarf-therapist {
      texlive = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-basic float caption wrapfig adjmulticol sidecap preprint enumitem;
      };
    };

    dwarf-therapist = callPackage ./dwarf-therapist/wrapper.nix { };

    themes = callPackage ./themes {
      stdenv = stdenvNoCC;
    };

    phoebus-theme = themes.phoebus;

    cla-theme = themes.cla;
  };

in self
