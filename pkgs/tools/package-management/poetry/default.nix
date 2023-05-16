{ lib
, python3
, fetchFromGitHub
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      poetry = self.callPackage ./unwrapped.nix { };

      # version overrides required by poetry and its plugins
<<<<<<< HEAD
      deepdiff = super.deepdiff.overridePythonAttrs (old: rec {
        doCheck = false;
      });
      poetry-core = super.poetry-core.overridePythonAttrs (old: rec {
        version = "1.7.0";
=======
      platformdirs = super.platformdirs.overridePythonAttrs (old: rec {
        version = "2.6.2";
        src = fetchFromGitHub {
          owner = "platformdirs";
          repo = "platformdirs";
          rev = "refs/tags/${version}";
          hash = "sha256-yGpDAwn8Kt6vF2K2zbAs8+fowhYQmvsm/87WJofuhME=";
        };
        SETUPTOOLS_SCM_PRETEND_VERSION = version;
      });
      poetry-core = super.poetry-core.overridePythonAttrs (old: rec {
        version = "1.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        src = fetchFromGitHub {
          owner = "python-poetry";
          repo = "poetry-core";
          rev = version;
<<<<<<< HEAD
          hash = "sha256-OfY2zc+5CgOrgbiPVnvMdT4h1S7Aek8S7iThl6azmsk=";
        };
        patches = [ ];
      });
    } // (plugins self);
  };

  plugins = ps: with ps; {
    poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
    poetry-plugin-export = callPackage ./plugins/poetry-plugin-export.nix { };
=======
          hash = "sha256-GpZ0vMByHTu5kl7KrrFFK2aZMmkNO7xOEc8NI2H9k34=";
        };
      });
    };
  };

  plugins = with python.pkgs; {
    poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    poetry-plugin-up = callPackage ./plugins/poetry-plugin-up.nix { };
  };

  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. poetry.withPlugins (ps: with ps; [ poetry-plugin-up ])
  withPlugins = selector: let
<<<<<<< HEAD
    selected = selector (plugins python.pkgs);
=======
    selected = selector plugins;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  in python.pkgs.toPythonApplication (python.pkgs.poetry.overridePythonAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ selected;

    # save some build time when adding plugins by disabling tests
    doCheck = selected == [ ];

    # Propagating dependencies leaks them through $PYTHONPATH which causes issues
    # when used in nix-shell.
    postFixup = ''
      rm $out/nix-support/propagated-build-inputs
    '';

<<<<<<< HEAD
    passthru = {
      plugins = plugins python.pkgs;
      inherit withPlugins python;
=======
    passthru = rec {
      inherit plugins withPlugins python;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  }));
in withPlugins (ps: [ ])
