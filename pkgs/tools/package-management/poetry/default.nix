{ lib
, python3
, fetchFromGitHub
, fetchPypi
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      poetry = self.callPackage ./unwrapped.nix { };

      # version overrides required by poetry and its plugins
      poetry-core = super.poetry-core.overridePythonAttrs (old: rec {
        version = "1.7.0";
        src = fetchFromGitHub {
          owner = "python-poetry";
          repo = "poetry-core";
          rev = version;
          hash = "sha256-OfY2zc+5CgOrgbiPVnvMdT4h1S7Aek8S7iThl6azmsk=";
        };
      });
    } // (plugins self);
  };

  plugins = ps: with ps; {
    poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
    poetry-plugin-export = callPackage ./plugins/poetry-plugin-export.nix { };
    poetry-plugin-up = callPackage ./plugins/poetry-plugin-up.nix { };
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
