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
, redis
, starlette
}:

buildPythonPackage rec {
  pname = "slowapi";
  version = "0.1.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "laurentS";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-IAB7JW8iVb5M610GVK0POXlSiya22KzNgr26BNvPC4Q=";
  };

  nativeBuildInputs = [
    poetry-core
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'limits = "^1.5"' 'limits = "*"' \
      --replace 'redis = "^3.4.1"' 'redis = "*"'
  '';

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
