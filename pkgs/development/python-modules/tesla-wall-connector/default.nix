{ lib
, aiohttp
, aioresponses
, aresponses
, backoff
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tesla-wall-connector";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "einarhauks";
    repo = pname;
    rev = version;
    sha256 = "sha256-JBtlGd9aHY8ikhpJ5v7ZcNu3BfLdBmOBZCMa6C0s6gE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];


  pythonImportsCheck = [
    "tesla_wall_connector"
  ];

  meta = with lib; {
    description = "Python library for communicating with a Tesla Wall Connector";
    homepage = "https://github.com/einarhauks/tesla-wall-connector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
