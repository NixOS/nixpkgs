{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "venstarcolortouch";
  version = "0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wrsu1SffD4/RvDiE6yABfZN/oSDH8Ao/RJK7yL2QKy8=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "venstarcolortouch" ];

  meta = with lib; {
    description = "Python interface for Venstar ColorTouch thermostats Resources";
    homepage = "https://github.com/hpeyerl/venstar_colortouch";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
