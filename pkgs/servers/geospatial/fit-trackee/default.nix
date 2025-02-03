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
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    rev = "refs/tags/v${version}";
    hash = "sha256-BY4bBz9yBgAJ28iriqweAWm7Df5jh/W7bNlInmjMU5Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'gunicorn = "^22.0.0"' 'gunicorn = "*"' \
      --replace-fail psycopg2-binary psycopg2
  '';

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = with python.pkgs; [
    authlib
    babel
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
  ] ++ dramatiq.optional-dependencies.redis;

  pythonImportsCheck = [ "fittrackee" ];

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    freezegun
    postgresqlTestHook
    postgresql
  ];

  pytestFlagsArray = [
    "fittrackee"
  ];

  postgresqlTestSetupPost = ''
    export DATABASE_TEST_URL=postgresql://$PGUSER/$PGDATABAS?host=$PGHOST
  '';

  postInstall = ''
    mkdir -p $out/var/share/fittrackee-instance
  '';

  preCheck = ''
    export TMP=$(mktemp -d)
  '';

  meta = {
    description = "Self-hosted outdoor activity tracker :bicyclist";
    homepage = "https://github.com/SamR1/FitTrackee";
    changelog = "https://github.com/SamR1/FitTrackee/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
