{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "venstarcolortouch";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HgUtGC2lXJ6BFhOnFK7DF4b/IooXIFPGcpJ4ru3kPNs=";
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
