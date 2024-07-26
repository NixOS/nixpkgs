{
  lib,
  anyio,
  asgi-lifespan,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  httpx,
  pdm-backend,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  starlette,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "sse-starlette";
  version = "2.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sysid";
    repo = "sse-starlette";
    rev = "refs/tags/v${version}";
    hash = "sha256-/aL0IkMdHNt7Ms1Et+xf00B9FGI31FuHAiJbxVMm3w0=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    anyio
    starlette
    uvicorn
  ];

  nativeCheckInputs = [
    asgi-lifespan
    fastapi
    httpx
    psutil
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "sse_starlette" ];

  disabledTests = [
    # AssertionError
    "test_stop_server_with_many_consumers"
    "test_stop_server_conditional"
  ];

  meta = with lib; {
    description = "Server Sent Events for Starlette and FastAPI";
    homepage = "https://github.com/sysid/sse-starlette";
    changelog = "https://github.com/sysid/sse-starlette/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
