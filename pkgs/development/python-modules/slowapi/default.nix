{ lib
, buildPythonPackage
, fastapi
, fetchFromGitHub
, limits
, mock
, hiro
, poetry-core
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, pythonRelaxDepsHook
, redis
, starlette
}:

buildPythonPackage rec {
  pname = "slowapi";
  version = "0.1.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "laurentS";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xgHz8b95SXf/GwzKPfQ/RHbUNJfCx6+7a2HB8+6hjsw=";
  };

  pythonRelaxDeps = [
    "limits"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '["redis^3.4.1"]' '["redis"]'
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    limits
    redis
  ];

  nativeCheckInputs = [
    fastapi
    hiro
    mock
    pytestCheckHook
    starlette
  ];

  disabledTests = [
    # AssertionError: Regex pattern 'parameter `request` must be an instance of starlette.requests.Request' does not match 'This portal is not running'.
    "test_endpoint_request_param_invalid"
    "test_endpoint_response_param_invalid"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    "test_multiple_decorators"
  ];

  pythonImportsCheck = [
    "slowapi"
  ];

  meta = with lib; {
    description = "Python library for API rate limiting";
    homepage = "https://github.com/laurentS/slowapi";
    changelog = "https://github.com/laurentS/slowapi/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
