{ lib
, stdenv
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
  ] ++ twisted.extras-require.tls;

  checkInputs = [
    httpbin
    twisted
  ];

  preCheck = lib.optionalString (stdenv.hostPlatform.system == "aarch64-darwin") ''
    # fails with: Cannot allocate write+execute memory for ffi.callback().
    rm src/treq/test/test_treq_integration.py
  '';

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
