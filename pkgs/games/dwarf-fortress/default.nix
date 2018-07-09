{ pkgs, stdenv, stdenvNoCC, gccStdenv, lib, recurseIntoAttrs }:

let
  callPackage = pkgs.newScope self;

  df-games = lib.listToAttrs (map (dfVersion: {
    name = "dwarf-fortress_${lib.replaceStrings ["."] ["_"] dfVersion}";
    value = callPackage ./wrapper {
      inherit (self) themes;
      dwarf-fortress = callPackage ./game.nix { inherit dfVersion; };
    };
  }) (lib.attrNames self.df-hashes));

  self = rec {
    df-hashes = builtins.fromJSON (builtins.readFile ./game.json);
    dwarf-fortress = df-games.dwarf-fortress_0_44_11;

    dfhack = callPackage ./dfhack {
      inherit (pkgs.perlPackages) XMLLibXML XMLLibXSLT;
      stdenv = gccStdenv;
    };

    soundSense = callPackage ./soundsense.nix { };

    # unfuck is linux-only right now, we will just use it there
    dwarf-fortress-unfuck = if stdenv.isLinux then callPackage ./unfuck.nix { }
                            else null;

    dwarf-therapist = callPackage ./dwarf-therapist/wrapper.nix {
      inherit (dwarf-fortress) dwarf-fortress;
      dwarf-therapist = pkgs.qt5.callPackage ./dwarf-therapist {
        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic float caption wrapfig adjmulticol sidecap preprint enumitem;
        };
      };
    };

    legends-browser = callPackage ./legends-browser {};

    themes = recurseIntoAttrs (callPackage ./themes {
      stdenv = stdenvNoCC;
    });

    # aliases
    phoebus-theme = themes.phoebus;
    cla-theme = themes.cla;
    dwarf-fortress-original = dwarf-fortress.dwarf-fortress;
  };

in self // df-games
