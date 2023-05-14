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
      flask-appbuilder = pySuper.flask-appbuilder.overridePythonAttrs (o: {
        meta.broken = false;
      });
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
    };
  };
in
# See note in pkgs/development/python-modules/apache-airflow/default.nix for
# instructions on manually testing the web UI
with python.pkgs; toPythonApplication apache-airflow
