{ stdenv, stdenvNoCC, gccStdenv, lib, recurseIntoAttrs, libsForQt5, newScope, perlPackages, jdk8, jre8 }:

# To whomever it may concern:
#
# This directory menaces with spikes of Nix code. It is terrifying.
#
# If this is your first time here, you should probably install the dwarf-fortress-full package,
# for instance with:
#
# environment.systemPackages = [ pkgs.dwarf-fortress-packages.dwarf-fortress-full ];
#
# You can adjust its settings by using override, or compile your own package by
# using the other packages here.
#
# For example, you can enable the FPS indicator, disable the intro, pick a
# theme other than phoebus (the default for dwarf-fortress-full), _and_ use
# an older version with something like:
#
# environment.systemPackages = [
#   (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
#      dfVersion = "0.44.11";
#      theme = "cla";
#      enableIntro = false;
#      enableFPS = true;
#   })
# ]
#
# Take a look at lazy-pack.nix to see all the other options.
#
# You will find the configuration files in ~/.local/share/df_linux/data/init. If
# you un-symlink them and edit, then the scripts will avoid overwriting your
# changes on later launches, but consider extending the wrapper with your
# desired options instead.

let
  inherit (lib)
    attrNames
    getAttr
    importJSON
    listToAttrs
    optionalAttrs
    recurseIntoAttrs
    replaceStrings
    versionAtLeast
    ;

  callPackage = newScope self;

  # The latest Dwarf Fortress version. Maintainers: when a new version comes
  # out, ensure that (unfuck|dfhack|twbt) are all up to date before changing
  # this. Note that unfuck and twbt are not required for 50.
  latestVersion = if stdenv.isLinux then "50.13"
                  else if stdenv.isDarwin then "0.47.05"
                  else throw "Unsupported system";

  # Converts a version to a package name.
  versionToName = version: "dwarf-fortress_${replaceStrings ["."] ["_"] version}";

  # A map of names to each Dwarf Fortress package we know about.
  df-games = listToAttrs (map
    (dfVersion: {
      name = versionToName dfVersion;
      value =
        let
          isAtLeast50 = versionAtLeast dfVersion "50.0";

          dwarf-fortress-unfuck = optionalAttrs (!isAtLeast50 && stdenv.isLinux) (callPackage ./unfuck.nix { inherit dfVersion; });

          dwarf-fortress = callPackage ./game.nix {
            inherit dfVersion;
            inherit dwarf-fortress-unfuck;
          };

          twbt = optionalAttrs (!isAtLeast50) (callPackage ./twbt { inherit dfVersion; });

          dfhack = callPackage ./dfhack {
            inherit (perlPackages) XMLLibXML XMLLibXSLT;
            inherit dfVersion;
            stdenv = gccStdenv;
          };

          dwarf-therapist = libsForQt5.callPackage ./dwarf-therapist/wrapper.nix {
            inherit dwarf-fortress;
            dwarf-therapist = (libsForQt5.callPackage ./dwarf-therapist {}).override (optionalAttrs (!isAtLeast50) {
              # 41.2.5 is the last version to support Dwarf Fortress 0.47.
              version = "41.2.5";
              hash = "sha256-xfYBtnO1n6OcliVt07GsQ9alDJIfWdVhtuyWwuvXSZs=";
            });
          };
        in
        callPackage ./wrapper {
          inherit (self) themes;
          inherit dwarf-fortress twbt dfhack dwarf-therapist;

          jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
        };
    })
    (attrNames self.df-hashes));

  self = rec {
    df-hashes = importJSON ./game.json;

    # Aliases for the latest Dwarf Fortress and the selected Therapist install
    dwarf-fortress = getAttr (versionToName latestVersion) df-games;
    dwarf-therapist = dwarf-fortress.dwarf-therapist;
    dwarf-fortress-original = dwarf-fortress.dwarf-fortress;

    dwarf-fortress-full = callPackage ./lazy-pack.nix {
      inherit df-games versionToName latestVersion;
    };

    soundSense = callPackage ./soundsense.nix { };

    legends-browser = callPackage ./legends-browser {
      jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
    };

    themes = recurseIntoAttrs (callPackage ./themes {
      stdenv = stdenvNoCC;
    });

    # Theme aliases
    phoebus-theme = themes.phoebus;
    cla-theme = themes.cla;
  };

in
self // df-games
