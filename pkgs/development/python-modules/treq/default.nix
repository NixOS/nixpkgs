{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  incremental,
  setuptools,

  # dependenices
  attrs,
  hyperlink,
  requests,
  twisted,

  # tests
  httpbin,
}:

buildPythonPackage rec {
  pname = "treq";
  version = "24.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fdp/xATz5O1Z0Kvl+O70lm+rvmGAOaKiO8fBUwXO/qg=";
  };

  nativeBuildInputs = [
    incremental
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    hyperlink
    incremental
    requests
    twisted
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    httpbin
    twisted
  ];

  checkPhase = ''
    runHook preCheck

    trial treq

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/twisted/treq";
    description = "Requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = [ ];
  };
}
