{
  asgi-lifespan,
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-regex-commit,
  httpx,
  itsdangerous,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  starlette,
}:

buildPythonPackage rec {
  pname = "starlette-csrf";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "starlette_csrf";
    inherit version;
    hash = "sha256-evrKjHLMPHJuWUJ3ivU0VGB8o+ZT/YbNde412M0c+nc=";
  };

  build-system = [
    hatchling
    hatch-regex-commit
  ];

  postPatch = ''
    substituteInPlace tests/test_middleware.py \
      --replace-fail \
        'httpx.AsyncClient(app=app, base_url="http://app.io")' \
        'httpx.AsyncClient(transport=httpx.ASGITransport(app=app), base_url="http://app.io")'
  '';

  dependencies = [
    itsdangerous
    starlette
  ];

  nativeCheckInputs = [
    asgi-lifespan
    httpx
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "starlette_csrf" ];

  meta = {
    description = "Starlette middleware implementing Double Submit Cookie CSRF protection";
    homepage = "https://github.com/frankie567/starlette-csrf";
    changelog = "https://github.com/frankie567/starlette-csrf/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
