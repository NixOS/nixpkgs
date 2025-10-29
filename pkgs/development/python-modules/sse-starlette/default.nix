{
  lib,
  anyio,
  asgi-lifespan,
  async-timeout,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  httpx,
  portend,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  starlette,
  tenacity,
  testcontainers,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "sse-starlette";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "sysid";
    repo = "sse-starlette";
    tag = "v${version}";
    hash = "sha256-9NI6CUcK5AqITKxtCMz9Z1+Ke87u2y2E0LlwsFUDhgw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyio
    starlette
  ];

  optional-dependencies = {
    examples = [ fastapi ];
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
    requests
    tenacity
    testcontainers
    uvicorn
  ];

  pythonImportsCheck = [ "sse_starlette" ];

  disabledTests = [
    # AssertionError
    "test_stop_server_with_many_consumers"
    "test_stop_server_conditional"
    # require network access
    "test_sse_multiple_consumers"
    # require docker
    "test_sse_server_termination"
  ];

  meta = with lib; {
    description = "Server Sent Events for Starlette and FastAPI";
    homepage = "https://github.com/sysid/sse-starlette";
    changelog = "https://github.com/sysid/sse-starlette/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
