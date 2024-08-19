{ lib
, python3
, fetchFromGitHub
, fetchPypi
, postgresql
, postgresqlTestHook
}:
let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy_1_4;

      flask-sqlalchemy = super.flask-sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.5";

        src = fetchPypi {
          pname = "flask_sqlalchemy";
          inherit version;
          hash = "sha256-xXZeWMoUVAG1IQbA9GF4VpJDxdolVWviwjHsxghnxbE=";
        };
      });
    };
  };

in
python.pkgs.buildPythonApplication rec {
  pname = "fit-trackee";
  version = "0.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    rev = "refs/tags/v${version}";
    hash = "sha256-lTDS+HfYG6ayXDotu7M2LUrw+1ZhQ0ftw0rTn4Mr3rQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail psycopg2-binary psycopg2
  '';

  build-system = [
    python.pkgs.poetry-core
  ];

  pythonRelaxDeps = [
    "flask-limiter"
    "gunicorn"
    "pyjwt"
    "pyopenssl"
  ];

  dependencies = with python.pkgs; [
    authlib
    babel
    click
    dramatiq
    flask
    flask-bcrypt
    flask-dramatiq
    flask-limiter
    flask-migrate
    flask-sqlalchemy
    gpxpy
    gunicorn
    humanize
    psycopg2
    pyjwt
    pyopenssl
    pytz
    shortuuid
    sqlalchemy
    staticmap
    ua-parser
  ] ++ dramatiq.optional-dependencies.redis
    ++ flask-limiter.optional-dependencies.redis;

  pythonImportsCheck = [ "fittrackee" ];

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    freezegun
    postgresqlTestHook
    postgresql
    time-machine
  ];

  pytestFlagsArray = [
    "fittrackee"
  ];

  postgresqlTestSetupPost = ''
    export DATABASE_TEST_URL=postgresql://$PGUSER/$PGDATABASE?host=$PGHOST
  '';

  preCheck = ''
    export TMP=$(mktemp -d)
  '';

  meta = {
    description = "Self-hosted outdoor activity tracker";
    homepage = "https://github.com/SamR1/FitTrackee";
    changelog = "https://github.com/SamR1/FitTrackee/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
