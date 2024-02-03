{ lib
, python3
, fetchPypi
, fetchFromGitHub
, fetchpatch
, git
, postgresql
, postgresqlTestHook
, redis
}:

let
  py = python3.override {
    packageOverrides = final: prev: {
      # sqlalchemy 1.4.x or 2.x are not supported
      sqlalchemy = prev.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
        doCheck = false;
      });
      alembic = prev.alembic.overridePythonAttrs (lib.const {
        doCheck = false;
      });
      factory-boy = prev.factory-boy.overridePythonAttrs (lib.const {
        doCheck = false;
      });
      beautifultable = prev.beautifultable.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-1E2VUbvte/qIZ1Mk+E77mqhXOE1E6fsh61MPCgutuBU=";
        };
        doCheck = false;
      });
    };
  };
in

py.pkgs.buildPythonPackage rec {
  pname = "irrd";
  version = "4.4.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "irrdnet";
    repo = "irrd";
    rev = "v${version}";
    hash = "sha256-vZSuBP44ZvN0mu2frcaQNZN/ilvKWIY9ETnrStzSnG0=";
  };
  patches = [
    # replace poetry dependency with poetry-core
    # https://github.com/irrdnet/irrd/pull/884
    (fetchpatch {
      url = "https://github.com/irrdnet/irrd/commit/4fb6e9b50d65729aff2d0a94c2e9b4e2daadea85.patch";
      hash = "sha256-DcE6VZfJkbHnPiEdYDpXea7S/8P0SmdvvJ42hywnpf0=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  nativeCheckInputs = [
    git
    redis
    postgresql
    postgresqlTestHook
  ] ++ (with py.pkgs; [
    pytest-asyncio
    pytest-freezegun
    pytestCheckHook
    smtpdfix
  ]);

  propagatedBuildInputs = with py.pkgs; [
    python-gnupg
    passlib
    bcrypt
    ipy
    ordered-set
    beautifultable
    pyyaml
    datrie
    setproctitle
    python-daemon
    pid
    py.pkgs.redis
    hiredis
    coredis
    requests
    pytz
    ariadne
    uvicorn
    starlette
    psutil
    asgiref
    pydantic
    typing-extensions
    py-radix-sr
    psycopg2
    sqlalchemy
    alembic
    ujson
    wheel
    websockets
    limits
    factory-boy
    webauthn
    wtforms
    imia
    starlette-wtf
    zxcvbn
    pyotp
    asgi-logger
    wtforms-bootstrap5
    email-validator
  ] ++ py.pkgs.uvicorn.optional-dependencies.standard;

  preCheck = ''
    redis-server &
    REDIS_PID=$!

    while ! redis-cli --scan ; do
      echo waiting for redis
      sleep 1
    done

    export SMTPD_HOST=127.0.0.1
    export IRRD_DATABASE_URL="postgres:///$PGDATABASE"
    export IRRD_REDIS_URL="redis://localhost/1"
  '';

  # required for test_object_writing_and_status_checking
  postgresqlTestSetupPost = ''
    echo "track_commit_timestamp=on" >> $PGDATA/postgresql.conf
    pg_ctl restart
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  # skip tests that require internet access
  disabledTests = [
    "test_020_dash_o_noop"
    "test_050_non_json_response"
  ];

  meta = with lib; {
    changelog = "https://irrd.readthedocs.io/en/v${version}/releases/";
    description = "An Internet Routing Registry database server, processing IRR objects in the RPSL format";
    license = licenses.mit;
    homepage = "https://github.com/irrdnet/irrd";
    maintainers = teams.wdz.members;
  };
}

