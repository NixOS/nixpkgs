{ lib
, aiohttp
, websockets
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "systembridge";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector-py";
    rev = "v${version}";
    sha256 = "sha256-dZOtvJXBXMKC+VOyQRMyaWAXg8lHjLcM2Zz9P0/ILT8=";
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
