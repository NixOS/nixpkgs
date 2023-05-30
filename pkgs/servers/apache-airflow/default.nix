{ lib
, fetchFromGitHub
, fetchPypi
, python3
}:

let
  python = python3.override {
    packageOverrides = pySelf: pySuper: {
      # flask-appbuilder doesn't work with sqlalchemy 2.x, flask-appbuilder 3.x
      # https://github.com/dpgaspar/Flask-AppBuilder/issues/2038
      flask-appbuilder = pySuper.flask-appbuilder.overridePythonAttrs (o: rec {
        version = "4.3.1";
        src = fetchPypi {
          pname = "Flask-AppBuilder";
          inherit version;
          hash = "sha256-FP92HEGOsufHtaIySqDiScD3QUu3iQhWdtvkOecUvuI=";
        };

        propagatedBuildInputs = o.propagatedBuildInputs ++ [
          pySelf.flask-limiter
        ];

        meta.broken = false;
      });
      # a knock-on effect from overriding the sqlalchemy version
      flask-sqlalchemy = pySuper.flask-sqlalchemy.overridePythonAttrs (o: {
        src = fetchPypi {
          pname = "Flask-SQLAlchemy";
          version = "2.5.1";
          hash = "sha256-K9pEtD58rLFdTgX/PMH4vJeTbMRkYjQkECv8LDXpWRI=";
        };
        format = "setuptools";
      });
      # apache-airflow doesn't work with sqlalchemy 2.x
      # https://github.com/apache/airflow/issues/28723
      sqlalchemy = pySuper.sqlalchemy.overridePythonAttrs (o: rec {
        version = "1.4.48";
        src = fetchFromGitHub {
          owner = "sqlalchemy";
          repo = "sqlalchemy";
          rev = "refs/tags/rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
          hash = "sha256-qyD3uoxEnD2pdVvwpUlSqHB3drD4Zg/+ov4CzLFIlLs=";
        };
      });
      # a version bump required by airflow 2.6.0 that missed the nixos
      # 23.05 deadline
      python-daemon = pySuper.python-daemon.overridePythonAttrs (o: rec {
        version = "3.0.1";
        src = fetchPypi {
          inherit version;
          pname = o.pname;
          sha256 = "sha256-bFdFI3L36v9Ak0ocA60YJr9eeTVY6H/vSRMeZGS02uU=";
        };

        patches = [];
        disabledTestPaths = [];

        pythonImportsCheck = lib.remove "daemon.runner" o.pythonImportsCheck;
      });

      apache-airflow = pySelf.callPackage ./python-package.nix { };
    };
  };
in
# See note in ./python-package.nix for
# instructions on manually testing the web UI
with python.pkgs; (toPythonApplication apache-airflow).overrideAttrs (_:{
  # Provide access to airflow's modified python package set
  # for the cases where external scripts need to import
  # airflow modules, though *caveat emptor* because many of
  # these packages will not be built by hydra and many will
  # not work at all due to the unexpected version overrides
  # here.
  passthru.pythonPackages = python.pkgs;
})
