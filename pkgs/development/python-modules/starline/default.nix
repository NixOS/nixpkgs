{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, requests
}:

buildPythonPackage rec {
  pname = "starline";
  version = "0.1.5";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1753f5fcd2a6976aed775afb03f8392159f040c673917cc0c634510d95c13cb9";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "starline" ];

  meta = with lib; {
    description = "Unofficial python library for StarLine API";
    homepage = "https://github.com/Anonym-tsk/starline";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
