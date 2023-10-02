{ lib
, python3
, fetchPypi
, git
, postgresql
, postgresqlTestHook
, redis
}:

let
  py = python3.override {
    packageOverrides = final: prev: {
      sqlalchemy = prev.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
        doCheck = false;
      });
      starlette = prev.starlette.overridePythonAttrs (oldAttrs: rec {
        version = "0.20.4";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-QvzzEi+Zj+/OPixa1+Xtvw8Cz2hdZGqDoI1ARyavUIQ=";
        };
        nativeBuildInputs = with final; [
          setuptools
        ];
        doCheck = false;
      });
      ariadne = prev.ariadne.overridePythonAttrs (oldAttrs: rec {
        version = "0.17.1";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-B98wl/NkNOyq99AKsVQem9TZ0meOnvg7IdWIEAI2vy8=";
        };
        nativeBuildInputs = with final; [
          setuptools
        ];
        doCheck = false;
      });
      alembic = prev.alembic.overridePythonAttrs (lib.const {
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
  version = "4.3.0.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hayfdcYAgIopfUiAR/AUWMuTzwpXvXuq6iPp9uhWN1M=";
  };

  patches = [
    ./irrd-asgiref-3.8.0.diff
  ];

  pythonRelaxDeps = true;
  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];
  postPatch = ''
    substituteInPlace setup.py --replace psycopg2-binary psycopg2
  '';

  nativeCheckInputs = [
    git
    redis
    postgresql
    postgresqlTestHook
  ] ++ (with py.pkgs; [
    pytest-asyncio
    pytest-freezegun
    pytestCheckHook
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
  ] ++ py.pkgs.uvicorn.optional-dependencies.standard;

  preCheck = ''
    redis-server &
    REDIS_PID=$!

    while ! redis-cli --scan ; do
      echo waiting for redis
      sleep 1
    done

    export IRRD_DATABASE_URL="postgres:///$PGDATABASE"
    export IRRD_REDIS_URL="redis://localhost/1"
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

