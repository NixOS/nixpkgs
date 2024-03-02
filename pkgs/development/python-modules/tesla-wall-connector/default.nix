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
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "einarhauks";
    repo = pname;
    rev = version;
    hash = "sha256-GblKXWV9h37E3bxNsx17hEe0uDm8ahzJUx8wiE+Vc38=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tesla_wall_connector"
  ];

  meta = with lib; {
    description = "Library for communicating with a Tesla Wall Connector";
    homepage = "https://github.com/einarhauks/tesla-wall-connector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
