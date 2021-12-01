{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, async_generator
, httpx
}:

buildPythonPackage rec {
  pname = "whodap";
  version = "0.1.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = pname;
    rev = "v${version}";
    sha256 = "1map5m9i1hi4wb9mpp7hq89n8x9bgsi7gclqfixgqhpi5v5gybqc";
  };

  propagatedBuildInputs = [
    httpx
  ] ++ lib.optionals (pythonOlder "3.7") [
    async_generator
  ];

  checkInputs = [
    asynctest
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_client.py"
  ];

  pythonImportsCheck = [ "whodap" ];

  meta = with lib; {
    description = "Python RDAP utility for querying and parsing information about domain names";
    homepage = "https://github.com/pogzyb/whodap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
