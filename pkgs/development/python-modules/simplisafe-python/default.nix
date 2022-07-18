{ lib
, aiohttp
, aresponses
, asynctest
, backoff
, beautifulsoup4
, buildPythonPackage
, docutils
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, types-pytz
, voluptuous
, websockets
}:

buildPythonPackage rec {
  pname = "simplisafe-python";
  version = "2022.07.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-v3N2f5B6BrwTb4ik2bME8OLzwsHZ3qWx+Jx1pv7KX8A=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    beautifulsoup4
    docutils
    pytz
    voluptuous
    websockets
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    types-pytz
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'docutils = "<0.18"' 'docutils = "*"'
  '';

  disabledTests = [
    # simplipy/api.py:253: InvalidCredentialsError
    "test_request_error_failed_retry"
    "test_update_error"
    # ClientConnectorError: Cannot connect to host auth.simplisafe.com:443 ssl:default [Temporary failure in name resolution]
    "test_client_async_from_refresh_token_unknown_error"
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "simplipy"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library the SimpliSafe API";
    homepage = "https://simplisafe-python.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
