{ pkgs, lib, fetchFromGitHub, python3Packages }:

with python3Packages;

let
  # officially supported database drivers
  dbDrivers = [
    psycopg2
    # sqlite driver is already shipped with python by default
  ];

in
buildPythonPackage rec {
  pname = "matrix-registration";
  version = "1.0.0.dev4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ZerataX";
    repo = pname;
    rev = "v${version}";
    sha256 = "00ky8gqs7860yy1mx7rfcdrmph4s9cqqg887sxxn5vjf3a6nhwnx";
  };

  postPatch = ''
    sed -i -e '/alembic>/d' setup.py
    sed -i -e 's/~=/>=/' setup.py
  '';

  propagatedBuildInputs = [
    appdirs
    flask
    flask-babel
    flask-cors
    flask-httpauth
    flask-limiter
    flask_sqlalchemy
    python-dateutil
    pyyaml
    requests
    waitress
    wtforms
  ] ++ dbDrivers;

  checkInputs = [
    flake8
    parameterized
  ];

  # `alembic` (a database migration tool) is only needed for the initial setup,
  # and not needed during the actual runtime. However `alembic` requires `matrix-registration`
  # in its environment to create a database schema from all models.
  #
  # Hence we need to patch away `alembic` from `matrix-registration` and create an `alembic`
  # which has `matrix-registration` in its environment.
  passthru.alembic = alembic.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ dbDrivers ++ [
      pkgs.matrix-registration
    ];
  });

  meta = with lib; {
    homepage = https://github.com/ZerataX/matrix-registration/;
    description = "a token based matrix registration api";
    license = licenses.mit;
    maintainers = with maintainers; [ zeratax ];
  };
}
