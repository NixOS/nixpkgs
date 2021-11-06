{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, websockets
}:

buildPythonPackage rec {
  pname = "systembridge";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector-py";
    rev = "v${version}";
    sha256 = "sha256-TYRsk47cVlXQ7RWyEGxXmxdHVES6WNbzdW8ZJSkVtb8=";
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
