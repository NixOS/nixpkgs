{ lib
, python3
, fetchFromGitHub
, fetchPypi
, postgresql
, postgresqlTestHook
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.49";
        src = fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-Bv8ly64ww5bEt3N0ZPKn/Deme32kCZk7GCsCTOyArtk=";
        };
        # Remove "test/typing" that does not exist
        disabledTestPaths = [
          "test/aaa_profiling"
          "test/ext/mypy"
        ];
      });
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
  version = "0.7.22";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    rev = "v${version}";
    hash = "sha256-aPQ8jLssN9nx0Bpd/44E3sQi2w0cR8ecG76DJjreeHA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace psycopg2-binary psycopg2 \
      --replace 'poetry>=0.12' 'poetry-core' \
      --replace 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python.pkgs; [
    authlib
    babel
    dramatiq
    flask
    flask-bcrypt
    flask-dramatiq
    flask-limiter
    flask-migrate
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

  meta = with lib; {
    description = "Self-hosted outdoor activity tracker :bicyclist";
    homepage = "https://github.com/SamR1/FitTrackee";
    changelog = "https://github.com/SamR1/FitTrackee/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
