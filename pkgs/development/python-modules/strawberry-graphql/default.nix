{
  lib,
  aiohttp,
  asgiref,
  buildPythonPackage,
  chalice,
  channels,
  daphne,
  django,
  email-validator,
  fastapi,
  fetchFromGitHub,
  flask,
  freezegun,
  graphql-core,
  inline-snapshot,
  libcst,
  opentelemetry-api,
  opentelemetry-sdk,
  poetry-core,
  pydantic,
  pygments,
  pyinstrument,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-django,
  pytest-emoji,
  pytest-flask,
  pytest-mock,
  pytest-snapshot,
  pytestCheckHook,
  python-dateutil,
  python-multipart,
  pythonOlder,
  rich,
  sanic,
  sanic-testing,
  starlette,
  typing-extensions,
  uvicorn,
  typer,
  graphlib-backport,
}:

buildPythonPackage rec {
  pname = "strawberry-graphql";
  version = "0.251.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry";
    rev = "refs/tags/${version}";
    hash = "sha256-khr4uwbRaO/7gw7N17qBRN1qnoMKw13lLzxEzBoB8TY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--emoji" "" \
  '';

  build-system = [ poetry-core ];

  dependencies = [
    graphql-core
    python-dateutil
    typing-extensions
  ];

  optional-dependencies = {
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
      typer
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
    pydantic = [ pydantic ];
    sanic = [ sanic ];
    fastapi = [
      fastapi
      python-multipart
    ];
    chalice = [ chalice ];
    cli = [
      pygments
      rich
      libcst
      typer
      graphlib-backport
    ];
    # starlite = [ starlite ];
    # litestar = [ litestar ];
    pyinstrument = [ pyinstrument ];
  };

  nativeCheckInputs = [
    daphne
    email-validator
    freezegun
    inline-snapshot
    pytest-asyncio
    pytest-emoji
    pytest-mock
    pytest-snapshot
    pytestCheckHook
    sanic-testing
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "strawberry" ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/cli/"
    "tests/django/test_dataloaders.py"
    "tests/exceptions/"
    "tests/http/"
    "tests/schema/extensions/"
    "tests/schema/test_dataloaders.py"
    "tests/schema/test_lazy/"
    "tests/test_dataloaders.py"
    "tests/utils/test_pretty_print.py"
    "tests/websockets/test_graphql_transport_ws.py"
    "tests/litestar/"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "GraphQL library for Python that leverages type annotations";
    homepage = "https://strawberry.rocks";
    changelog = "https://github.com/strawberry-graphql/strawberry/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ izorkin ];
    mainProgram = "strawberry";
  };
}
