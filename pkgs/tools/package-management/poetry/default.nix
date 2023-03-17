{ lib
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      poetry = self.callPackage ./unwrapped.nix { };

      # version overrides required by poetry and its plugins
      dulwich = super.dulwich.overridePythonAttrs (old: rec {
        version = "0.20.50";
        src = self.fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-UKlBeWssZ1vjm+co1UDBa1t853654bP4VWUOzmgy0r4=";
        };
      });
    };
  };

  plugins = with python.pkgs; {
    poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
    poetry-plugin-up = callPackage ./plugins/poetry-plugin-up.nix { };
  };

  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. poetry.withPlugins (ps: with ps; [ poetry-plugin-up ])
  withPlugins = selector: let
    selected = selector plugins;
  in python.pkgs.toPythonApplication (python.pkgs.poetry.overridePythonAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ selected;

    # save some build time when adding plugins by disabling tests
    doCheck = selected == [ ];

    # Propagating dependencies leaks them through $PYTHONPATH which causes issues
    # when used in nix-shell.
    postFixup = ''
      rm $out/nix-support/propagated-build-inputs
    '';

    passthru = rec {
      inherit plugins withPlugins;
    };
  }));
in withPlugins (ps: [ ])
