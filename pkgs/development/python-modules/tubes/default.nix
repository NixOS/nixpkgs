{ lib, buildPythonPackage, fetchPypi, python
, characteristic, six, twisted
}:

buildPythonPackage rec {
  pname = "tubes";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "Tubes";
    inherit version;
    hash = "sha256-WbkZfy+m9/xrwygd5VeXrccpu3XJxhO09tbEFZnw14s=";
  };

  propagatedBuildInputs = [ characteristic six twisted ];

  checkPhase = ''
    ${python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tubes
  '';

  pythonImportsCheck = [ "tubes" ];

  meta = with lib; {
    description = "a data-processing and flow-control engine for event-driven programs";
    homepage    = "https://github.com/twisted/tubes";
    license     = licenses.mit;
    maintainers = with maintainers; [ exarkun ];
  };
}
