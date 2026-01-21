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

buildPythonPackage rec {
  pname = "slowapi";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laurentS";
    repo = "slowapi";
    tag = "v${version}";
    hash = "sha256-R/Mr+Qv22AN7HCDGmAUVh4efU8z4gMIyhC0AuKmxgdE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
  ];

  pythonImportsCheck = [ "slowapi" ];

  meta = {
    description = "Python library for API rate limiting";
    homepage = "https://github.com/laurentS/slowapi";
    changelog = "https://github.com/laurentS/slowapi/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
