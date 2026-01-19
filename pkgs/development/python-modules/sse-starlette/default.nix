{
  lib,
  aiosqlite,
  anyio,
  asgi-lifespan,
  async-timeout,
  buildPythonPackage,
  daphne,
  fastapi,
  fetchFromGitHub,
  granian,
  httpx,
  portend,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
  starlette,
  tenacity,
  testcontainers,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "sse-starlette";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sysid";
    repo = "sse-starlette";
    tag = "v${version}";
    hash = "sha256-2QCagK4OIVJJ54uedJFVjcGyRo2j1415iNjDIa67/mo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyio
  ];

  optional-dependencies = {
    daphne = [ daphne ];
    examples = [
      aiosqlite
      fastapi
      sqlalchemy
      starlette
      uvicorn
    ]
    ++ sqlalchemy.optional-dependencies.asyncio;
    granian = [ granian ];
    uvicorn = [ uvicorn ];
  };

  nativeCheckInputs = [
    asgi-lifespan
    async-timeout
    fastapi
    httpx
    portend
    psutil
    pytest-asyncio
    pytestCheckHook
    tenacity
    testcontainers
    uvicorn
  ];

  pythonImportsCheck = [ "sse_starlette" ];

  disabledTests = [
    # AssertionError
    "test_stop_server_with_many_consumers"
    # require docker
    "test_sse_server_termination"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Server Sent Events for Starlette and FastAPI";
    homepage = "https://github.com/sysid/sse-starlette";
    changelog = "https://github.com/sysid/sse-starlette/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
