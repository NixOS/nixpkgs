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
  version = "23.11.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CRT/kp/RYyzhZ5cjUmD4vBnSD/fEWcHeq9ZbjGjL6sU=";
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
    maintainers = with maintainers; [ ];
  };
}
