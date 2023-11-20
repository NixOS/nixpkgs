{ lib
, aiohttp
, asgiref
, buildPythonPackage
, chalice
, channels
, click
, daphne
, django
, email-validator
, fastapi
, fetchFromGitHub
, fetchpatch
, flask
, freezegun
, graphql-core
, libcst
, opentelemetry-api
, opentelemetry-sdk
, poetry-core
, pydantic
, pygments
, pyinstrument
, pytest-aiohttp
, pytest-asyncio
, pytest-django
, pytest-emoji
, pytest-flask
, pytest-mock
, pytest-snapshot
, pytestCheckHook
, python-dateutil
, python-multipart
, pythonOlder
, rich
, sanic
, sanic-testing
, starlette
, typing-extensions
, uvicorn
}:

buildPythonPackage rec {
  pname = "strawberry-graphql";
  version = "0.215.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry";
    rev = "refs/tags/${version}";
    hash = "sha256-7jWG9bk7NN3BhpzS2fi7OkAsxL0446hnqiNqhwiBGHc=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/strawberry-graphql/strawberry/pull/2199
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/strawberry-graphql/strawberry/commit/710bb96f47c244e78fc54c921802bcdb48f5f421.patch";
      hash = "sha256-ekUZ2hDPCqwXp9n0YjBikwSkhCmVKUzQk7LrPECcD7Y=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--emoji --mypy-ini-file=mypy.ini" "" \
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    graphql-core
    python-dateutil
    typing-extensions
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
      pytest-aiohttp
    ];
    asgi = [
      starlette
      python-multipart
    ];
    debug = [
      rich
      libcst
    ];
    debug-server = [
      click
      libcst
      pygments
      python-multipart
      rich
      starlette
      uvicorn
    ];
    django = [
      django
      pytest-django
      asgiref
    ];
    channels = [
      channels
      asgiref
    ];
    flask = [
      flask
      pytest-flask
    ];
    opentelemetry = [
      opentelemetry-api
      opentelemetry-sdk
    ];
    pydantic = [
      pydantic
    ];
    sanic = [
      sanic
    ];
    fastapi = [
      fastapi
      python-multipart
    ];
    chalice = [
      chalice
    ];
    cli = [
      click
      pygments
      rich
      libcst
    ];
    # starlite = [
    #   starlite
    # ];
    pyinstrument = [
      pyinstrument
    ];
  };

  nativeCheckInputs = [
    daphne
    email-validator
    freezegun
    pytest-asyncio
    pytest-emoji
    pytest-mock
    pytest-snapshot
    pytestCheckHook
    sanic-testing
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "strawberry"
  ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/cli/"
    "tests/django/test_dataloaders.py"
    "tests/exceptions/"
    "tests/http/"
    "tests/mypy/test_plugin.py" # avoid dependency on mypy
    "tests/schema/extensions/"
    "tests/schema/test_dataloaders.py"
    "tests/schema/test_lazy/"
    "tests/starlite/"
    "tests/test_dataloaders.py"
    "tests/utils/test_pretty_print.py"
    "tests/websockets/test_graphql_transport_ws.py"
  ];

  meta = with lib; {
    description = "A GraphQL library for Python that leverages type annotations";
    homepage = "https://strawberry.rocks";
    changelog = "https://github.com/strawberry-graphql/strawberry/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ izorkin ];
  };
}
