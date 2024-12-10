{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3,
}:

let
  python = python3.override {
    packageOverrides = pySelf: pySuper: {
      connexion = pySuper.connexion.overridePythonAttrs (o: rec {
        version = "2.14.2";
        src = fetchFromGitHub {
          owner = "spec-first";
          repo = "connexion";
          rev = "refs/tags/${version}";
          hash = "sha256-1v1xCHY3ZnZG/Vu9wN/it7rLKC/StoDefoMNs+hMjIs=";
        };
        nativeBuildInputs = with pySelf; [
          setuptools
          pythonRelaxDepsHook
        ];
        pythonRelaxDeps = [
          "werkzeug"
        ];
        propagatedBuildInputs = with pySelf; [
          aiohttp
          aiohttp-jinja2
          aiohttp-swagger
          clickclick
          flask
          inflection
          jsonschema
          openapi-spec-validator
          packaging
          pyyaml
          requests
          swagger-ui-bundle
        ];
        nativeCheckInputs = with pySelf; [
          aiohttp-remotes
          decorator
          pytest-aiohttp
          pytestCheckHook
          testfixtures
        ];
        disabledTests = [
          "test_app"
          "test_openapi_yaml_behind_proxy"
          "test_swagger_ui"
        ];
      });
      flask = pySuper.flask.overridePythonAttrs (o: rec {
        version = "2.2.5";
        src = fetchPypi {
          pname = "Flask";
          inherit version;
          hash = "sha256-7e6bCn/yZiG9WowQ/0hK4oc3okENmbC7mmhQx/uXeqA=";
        };
        nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [
          pySelf.setuptools
        ];
      });
      # flask-appbuilder doesn't work with sqlalchemy 2.x, flask-appbuilder 3.x
      # https://github.com/dpgaspar/Flask-AppBuilder/issues/2038
      flask-appbuilder = pySuper.flask-appbuilder.overridePythonAttrs (o: {
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
      httpcore = pySuper.httpcore.overridePythonAttrs (o: rec {
        # nullify upstream's pytest flags which cause
        # "TLS/SSL connection has been closed (EOF)"
        # with pytest-httpbin 1.x
        preCheck = ''
          substituteInPlace pyproject.toml \
            --replace '[tool.pytest.ini_options]' '[tool.notpytest.ini_options]'
        '';
      });
      pytest-httpbin = pySuper.pytest-httpbin.overridePythonAttrs (o: rec {
        version = "1.0.2";
        src = fetchFromGitHub {
          owner = "kevin1024";
          repo = "pytest-httpbin";
          rev = "refs/tags/v${version}";
          hash = "sha256-S4ThQx4H3UlKhunJo35esPClZiEn7gX/Qwo4kE1QMTI=";
        };
      });
      # apache-airflow doesn't work with sqlalchemy 2.x
      # https://github.com/apache/airflow/issues/28723
      sqlalchemy = pySuper.sqlalchemy_1_4;

      apache-airflow = pySelf.callPackage ./python-package.nix { };
    };
  };
in
# See note in ./python-package.nix for
# instructions on manually testing the web UI
with python.pkgs;
(toPythonApplication apache-airflow).overrideAttrs (previousAttrs: {
  # Provide access to airflow's modified python package set
  # for the cases where external scripts need to import
  # airflow modules, though *caveat emptor* because many of
  # these packages will not be built by hydra and many will
  # not work at all due to the unexpected version overrides
  # here.
  passthru = (previousAttrs.passthru or { }) // {
    pythonPackages = python.pkgs;
  };
})
