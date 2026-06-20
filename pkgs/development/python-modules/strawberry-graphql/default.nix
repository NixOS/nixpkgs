{
  lib,
  aiohttp,
  asgiref,
  buildPythonPackage,
  chalice,
  channels,
  cross-web,
  daphne,
  django,
  email-validator,
  fastapi,
  fetchFromGitHub,
  flask,
  freezegun,
  graphlib-backport,
  graphql-core,
  inline-snapshot,
  libcst,
  opentelemetry-api,
  opentelemetry-sdk,
  protobuf,
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
  rich,
  sanic-testing,
  sanic,
  starlette,
  typer,
  typing-extensions,
  uv-build,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "strawberry-graphql";
  version = "0.316.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawberry-graphql";
    repo = "strawberry";
    tag = finalAttrs.version;
    hash = "sha256-z9ZqIW0DD5/o2nuHqEjcjIaaHMMiT6jRoFddroSPP24=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11,<0.12" "uv_build"
    substituteInPlace pyproject.toml \
      --replace-fail "--emoji" ""
  '';

  build-system = [ uv-build ];

  dependencies = [
    cross-web
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
    apollo-federation = [ protobuf ];
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
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "strawberry" ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/cli/"
    "tests/django/test_dataloaders.py"
    "tests/exceptions/"
    "tests/experimental/pydantic/test_fields.py"
    "tests/http/"
    "tests/schema/extensions/"
    "tests/schema/test_dataloaders.py"
    "tests/schema/test_lazy/"
    "tests/sanic/test_file_upload.py"
    "tests/test_dataloaders.py"
    "tests/websockets/test_graphql_transport_ws.py"
    "tests/litestar/"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "GraphQL library for Python that leverages type annotations";
    homepage = "https://strawberry.rocks";
    changelog = "https://github.com/strawberry-graphql/strawberry/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ izorkin ];
    mainProgram = "strawberry";
  };
})
