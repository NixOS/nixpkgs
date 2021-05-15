{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "venstarcolortouch";
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04y9gmxb0vsmc5c930x9ziis5v83b29kfzsgjlww3pssj69lmw1s";
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
