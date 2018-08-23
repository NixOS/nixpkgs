{ pkgs, stdenv, stdenvNoCC, gccStdenv, lib, recurseIntoAttrs }:

# To whomever it may concern:
#
# This directory menaces with spikes of Nix code. It is terrifying.
#
# If this is your first time here, you should probably install the dwarf-fortress-full package,
# for instance with `environment.systempackages = [ pkgs.dwarf-fortress.dwarf-fortress-full ];`.
#
# You can adjust its settings by using override, or compile your own package by
# using the other packages here. Take a look at lazy-pack.nix to get an idea of
# how.
#
# You will find the configuration files in ~/.local/share/df_linux/data/init. If
# you un-symlink them and edit, then the scripts will avoid overwriting your
# changes on later launches, but consider extending the wrapper with your
# desired options instead.
#
# Although both dfhack and dwarf therapist are included in the lazy pack, you
# can only use one at a time. DFHack does have therapist-like features, so this
# may or may not be a problem.

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
    dwarf-fortress = df-games.dwarf-fortress_0_44_12;

    dwarf-fortress-full = callPackage ./lazy-pack.nix { };

    dfhack = callPackage ./dfhack {
      inherit (pkgs.perlPackages) XMLLibXML XMLLibXSLT;
      stdenv = gccStdenv;
    };

    soundSense = callPackage ./soundsense.nix { };

    # unfuck is linux-only right now, we will only use it there.
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

    twbt = callPackage ./twbt {};
    themes = recurseIntoAttrs (callPackage ./themes { });

    # aliases
    phoebus-theme = themes.phoebus;
    cla-theme = themes.cla;
    dwarf-fortress-original = dwarf-fortress.dwarf-fortress;
  };

in self // df-games
