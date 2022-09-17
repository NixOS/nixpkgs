{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "venstarcolortouch";
  version = "0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ucz0Ejpgiss8boF8dzt45FwpieNoJ6S3DUvtay6FDrw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "venstarcolortouch"
  ];

  meta = with lib; {
    description = "Python interface for Venstar ColorTouch thermostats Resources";
    homepage = "https://github.com/hpeyerl/venstar_colortouch";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
