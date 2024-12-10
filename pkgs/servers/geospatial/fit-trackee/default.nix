{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  postgresql,
  postgresqlTestHook,
}:
let
  python = python3.override {
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
  version = "0.7.31";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    rev = "v${version}";
    hash = "sha256-qKUdpuxslhS6k9EiWvbU/0hSXH1y9mjhXs02pugTF3g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail psycopg2-binary psycopg2 \
      --replace-fail 'flask = "^3.0.2"' 'flask = "*"' \
      --replace-fail 'pyopenssl = "^24.0.0"' 'pyopenssl = "*"' \
      --replace-fail 'sqlalchemy = "=1.4.51"' 'sqlalchemy = "*"'
  '';

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs =
    with python.pkgs;
    [
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
    ]
    ++ dramatiq.optional-dependencies.redis;

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

  meta = with lib; {
    description = "Self-hosted outdoor activity tracker :bicyclist";
    homepage = "https://github.com/SamR1/FitTrackee";
    changelog = "https://github.com/SamR1/FitTrackee/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
