{ pkgs, pkgsi686Linux }:

let
  callPackage = pkgs.newScope self;
  callPackage_i686 = pkgsi686Linux.newScope self;

  self = rec {
    dwarf-fortress-original = callPackage ./game.nix { };

    dfhack = callPackage_i686 ./dfhack {
      inherit (pkgsi686Linux.perlPackages) XMLLibXML XMLLibXSLT;
      protobuf = with pkgsi686Linux; protobuf.override {
        stdenv = overrideInStdenv stdenv [ useOldCXXAbi ];
      };
    };

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
