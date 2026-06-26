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
  pydantic,
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
  version = "3.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sysid";
    repo = "sse-starlette";
    tag = "v${version}";
    hash = "sha256-b0iNu9CN4Tca2hGU0Rpr/v0Q4KWNPQNCp9BY5YnzjzA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyio
    starlette
  ];

  optional-dependencies = {
    daphne = [ daphne ];
    examples = [
      fastapi
      pydantic
      uvicorn
    ];
    examples_db = [
      aiosqlite
      sqlalchemy
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
