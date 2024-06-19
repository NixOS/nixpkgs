{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  httpx,
}:

buildPythonPackage rec {
  pname = "whodap";
  version = "0.1.12";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kw7bmkpDNb/PK/Q2tSbG+ju0G+6tdSy3RaNDaNOVYnE=";
  };

  propagatedBuildInputs = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
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
    changelog = "https://github.com/pogzyb/whodap/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
