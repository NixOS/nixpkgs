{ lib, python3, fetchFromGitHub }:

let
  newPackageOverrides =
    self: super: {
      poetry = self.callPackage ./unwrapped.nix { };

      # The versions of Poetry and poetry-core need to match exactly,
      # and poetry-core in nixpkgs requires a staging cycle to be updated,
      # so apply an override here.
      #
      # We keep the override around even when the versions match, as
      # it's likely to become relevant again after the next Poetry update.
      poetry-core = super.poetry-core.overridePythonAttrs (old: rec {
        version = "1.9.0";
        src = fetchFromGitHub {
          owner = "python-poetry";
          repo = "poetry-core";
          rev = "refs/tags/${version}";
          hash = "sha256-vvwKbzGlvv2LTbXfJxQVM3nUXFGntgJxsku6cbRxCzw=";
        };
      });
    } // (plugins self);
  python = python3.override (old: {
    self = python;
    packageOverrides = lib.composeManyExtensions
      ((if old ? packageOverrides then [ old.packageOverrides ] else [ ]) ++ [ newPackageOverrides ]);
  });

  plugins = ps: with ps; {
    poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
    poetry-plugin-export = callPackage ./plugins/poetry-plugin-export.nix { };
    poetry-plugin-up = callPackage ./plugins/poetry-plugin-up.nix { };
    poetry-plugin-poeblix = callPackage ./plugins/poetry-plugin-poeblix.nix { };
  };

  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. poetry.withPlugins (ps: with ps; [ poetry-plugin-up ])
  withPlugins = selector: let
    selected = selector (plugins python.pkgs);
  in python.pkgs.toPythonApplication (python.pkgs.poetry.overridePythonAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ selected;

    # save some build time when adding plugins by disabling tests
    doCheck = selected == [ ];

    # Propagating dependencies leaks them through $PYTHONPATH which causes issues
    # when used in nix-shell.
    postFixup = ''
      rm $out/nix-support/propagated-build-inputs
    '';

    passthru = {
      plugins = plugins python.pkgs;
      inherit withPlugins python;
    };
  }));
in withPlugins (ps: [ ])
