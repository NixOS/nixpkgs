{ lib
, aiohttp
, aresponses
, async-timeout
, attrs
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "seventeentrack";
  version = "2022.04.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "McSwindler";
    repo = pname;
    rev = version;
    hash = "sha256-IaR0Cfs3FL4Vguc2NLdPaunk23zC8B93Iyqe9xY/hWY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    attrs
    pytz
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "seventeentrack"
  ];

  meta = with lib; {
    description = "Python library to track package info from 17track.com";
    homepage = "https://github.com/McSwindler/seventeentrack";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
