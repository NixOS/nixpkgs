{ lib
, python3
, fetchFromGitHub
, fetchPypi
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      poetry = self.callPackage ./unwrapped.nix { };

      filelock = super.filelock.overridePythonAttrs (old: rec {
        version = "3.12.2";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-ACdAUY2KpZomsMduEPuMbhXq6CXTS2/fZwMz/XuTjYE=";
        };
        nativeCheckInputs = with self; [
          pytest-mock
          pytestCheckHook
        ];
      });
      # version overrides required by poetry and its plugins
      platformdirs = super.platformdirs.overridePythonAttrs (old: rec {
        version = "3.8.0";
        src = fetchFromGitHub {
          owner = "platformdirs";
          repo = "platformdirs";
          rev = "refs/tags/${version}";
          hash = "sha256-eQAEHl61aC/B44G3zBqMjDVAQF8GerpJbeQ1nT4uQ4Q=";
        };
        SETUPTOOLS_SCM_PRETEND_VERSION = version;
      });
      poetry-core = super.poetry-core.overridePythonAttrs (old: rec {
        version = "1.6.1";
        src = fetchFromGitHub {
          owner = "python-poetry";
          repo = "poetry-core";
          rev = version;
          hash = "sha256-Gc22Y2T4uO39jiOqEUFeOfnVCbknuDjmzFPZgk2eY74=";
        };
        nativeCheckInputs = old.nativeCheckInputs ++ [
          self.tomli-w
        ];
      });
      virtualenv = super.virtualenv.overridePythonAttrs (old: rec {
        version = "20.23.1";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-j/GaOMECHHQhSO3E+By0PX+MaBbS7eKrcq9bhMdJreE=";
        };
        nativeCheckInputs = old.nativeCheckInputs ++ [
          self.time-machine
        ];
      });
      poetry-plugin-export = super.poetry-plugin-export.overridePythonAttrs(old: {
        version = "1.4.0";
        src = fetchFromGitHub {
          owner = "python-poetry";
          repo = old.pname;
          rev = "refs/tags/${old.version}";
          hash = "sha256-okI91Z9u5w7IHpPb9jL4Hb8+MkYJEF2qm0mqqCdyKbk=";
        };
      });
    };
  };

  plugins = with python.pkgs; {
    poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
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

    passthru = {
      inherit plugins withPlugins python;
    };
  }));
in withPlugins (ps: [ ])
