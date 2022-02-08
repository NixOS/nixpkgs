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
  version = "0.1.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L8fSf9AhmWbRvLKvf0aowKoal+5dG1SJXcA7Ssrhj6o=";
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
