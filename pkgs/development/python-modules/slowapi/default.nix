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
  pythonAtLeast,
  pythonOlder,
  redis,
  starlette,
}:

buildPythonPackage rec {
  pname = "slowapi";
  version = "0.1.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "laurentS";
    repo = "slowapi";
    rev = "refs/tags/v${version}";
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
    # AssertionError: Regex pattern 'parameter `request` must be an instance of starlette.requests.Request' does not match 'This portal is not running'.
    "test_endpoint_request_param_invalid"
    "test_endpoint_response_param_invalid"
  ] ++ lib.optionals (pythonAtLeast "3.10") [ "test_multiple_decorators" ];

  pythonImportsCheck = [ "slowapi" ];

  meta = with lib; {
    description = "Python library for API rate limiting";
    homepage = "https://github.com/laurentS/slowapi";
    changelog = "https://github.com/laurentS/slowapi/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
