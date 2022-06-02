{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "starline";
  version = "0.2.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "550b00ab95cf59d933f7708abab40a4e41e5790e62b653471afe86a3af3320e6";
  };

  propagatedBuildInputs = [
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
