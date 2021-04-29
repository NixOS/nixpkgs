{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "screenlogicpy";
  version = "0.4.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Hj+AS8YN7ZtmgY5sUj4TmQspzeiKiLz6dBbmjhGCgXI=";
  };

  # Project doesn't publish tests
  # https://github.com/dieselrabbit/screenlogicpy/issues/8
  doCheck = false;
  pythonImportsCheck = [ "screenlogicpy" ];

  meta = with lib; {
    description = "Python interface for Pentair Screenlogic devices";
    homepage = "https://github.com/dieselrabbit/screenlogicpy";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
