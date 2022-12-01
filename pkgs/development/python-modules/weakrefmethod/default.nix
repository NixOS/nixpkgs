{ stdenv, lib, buildPythonPackage, fetchPypi, unittest2 }:

buildPythonPackage rec {
  pname = "weakrefmethod";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N7wfu1V1rPghctTre2/EQS131aHXDf8sH4pFdDAc2mY=";
  };

  checkInputs = [
    unittest2
  ];

  pythonImportsCheck = [ "weakrefmethod" ];

  meta = with lib; {
    description = "A WeakMethod class for storing bound methods using weak references";
    homepage = "https://github.com/twang817/weakrefmethod";
    license = licenses.psfl;
    maintainers = with maintainers; [ myaats ];
  };
}
