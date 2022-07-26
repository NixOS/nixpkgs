{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyroute2
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "unifi-discovery";
  version = "1.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WO1oLD09fokMR7lVCqs1Qeodjc+Yg431otl9rohtmPo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pyroute2
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=unifi_discovery --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "unifi_discovery"
  ];

  meta = with lib; {
    description = "Module to discover Unifi devices";
    homepage = "https://github.com/bdraco/unifi-discovery";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
