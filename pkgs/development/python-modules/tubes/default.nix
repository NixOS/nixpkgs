{ lib, buildPythonPackage, fetchPypi, python
, characteristic, six, twisted
}:

buildPythonPackage rec {
  pname = "tubes";
  version = "0.2.0";

  src = fetchPypi {
    pname = "Tubes";
    inherit version;
    sha256 = "0sg1gg2002h1xsgxigznr1zk1skwmhss72dzk6iysb9k9kdgymcd";
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
