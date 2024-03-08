{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, websockets
}:

buildPythonPackage rec {
  pname = "systembridge";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector-py";
    rev = "v${version}";
    hash = "sha256-Ts8zPRK6S5iLnl19Y/Uz0YAh6hDeVRNBY6HsvLwdUFw=";
  };

  propagatedBuildInputs = [
    aiohttp
    websockets
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "systembridge" ];

  meta = with lib; {
    description = "Python module for connecting to System Bridge";
    homepage = "https://github.com/timmo001/system-bridge-connector-py";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
