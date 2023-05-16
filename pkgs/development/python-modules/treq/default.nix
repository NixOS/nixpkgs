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
    hash = "sha256-33V+PxQfx4Lt4HamBFIRlP/LQPomRc9I5aNwYDB/Uuw=";
  };

  propagatedBuildInputs = [
    requests
    incremental
    twisted
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
