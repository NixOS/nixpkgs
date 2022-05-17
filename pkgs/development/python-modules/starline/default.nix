{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, requests
}:

buildPythonPackage rec {
  pname = "starline";
  version = "0.2.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VQsAq5XPWdkz93CKurQKTkHleQ5itlNHGv6Go68zIOY=";
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
