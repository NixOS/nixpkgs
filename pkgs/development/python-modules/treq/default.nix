{ lib
, fetchPypi
, buildPythonPackage
, requests
, twisted
, incremental
, httpbin
}:

buildPythonPackage rec {
  pname = "treq";
  version = "22.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-33V+PxQfx4Lt4HamBFIRlP/LQPomRc9I5aNwYDB/Uuw=";
  };

  propagatedBuildInputs = [
    requests
    incremental
    twisted
  ] ++ twisted.optional-dependencies.tls;

  checkInputs = [
    httpbin
    twisted
  ];

  checkPhase = ''
    trial treq
  '';

  meta = with lib; {
    homepage = "https://github.com/twisted/treq";
    description = "Requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
