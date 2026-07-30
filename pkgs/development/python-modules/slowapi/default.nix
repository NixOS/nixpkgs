{
  lib,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  limits,
  mock,
  hiro,
  httpx,
  poetry-core,
  pytestCheckHook,
  redis,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "slowapi";
  version = "0.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laurentS";
    repo = "slowapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YNL/xfs8fmkAGagMhqJX3tXoltjHznZjUrF/a2RWCDs=";
  };

  patches = [
    # https://github.com/laurentS/slowapi/pull/279
    ./starlette-1.0-compat.patch
  ];

  build-system = [ poetry-core ];

  dependencies = [
    limits
    redis
  ];

  nativeCheckInputs = [
    fastapi
    hiro
    httpx
    mock
    pytestCheckHook
    starlette
  ];

  disabledTests = [
    # AssertionError: assert '1740326049.9886339' == '1740326049'
    "test_headers_no_breach"
    "test_headers_breach"
    # tests use @app.route() removed in Starlette 1.0
    # https://github.com/laurentS/slowapi/issues/271
    "test_retry_after"
    "test_exempt_decorator"
  ];

  pythonImportsCheck = [ "slowapi" ];

  meta = {
    description = "Python library for API rate limiting";
    homepage = "https://github.com/laurentS/slowapi";
    changelog = "https://github.com/laurentS/slowapi/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
