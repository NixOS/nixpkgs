{ pkgs, pkgsi686Linux }:

let
  callPackage = pkgs.newScope self;
  callPackage_i686 = pkgsi686Linux.newScope self;

  self = rec {
    dwarf-fortress-original = callPackage ./game.nix { };

    dfhack = callPackage ./dfhack {
      inherit (pkgs.perlPackages) XMLLibXML XMLLibXSLT;
    };

    soundSense = callPackage ./soundsense.nix { };

    dwarf-fortress-unfuck = callPackage ./unfuck.nix { };

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

    phoebus-theme = callPackage ./themes/phoebus.nix { };

    cla-theme = callPackage ./themes/cla.nix { };
  };

in self
