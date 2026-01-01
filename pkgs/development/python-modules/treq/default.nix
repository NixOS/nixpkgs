{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  incremental,
  hatchling,

  # dependencies
  attrs,
  hyperlink,
  multipart,
  requests,
  twisted,

  # tests
  httpbin,
}:

buildPythonPackage rec {
  pname = "treq";
  version = "25.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jd3jpVroXsLyxWMyyZrvJVqxT5l9DQBVLr/xNTipgEo=";
  };

  nativeBuildInputs = [
    incremental
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    hyperlink
    incremental
    multipart
    requests
    twisted
  ]
  ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    httpbin
    twisted
  ];

  checkPhase = ''
    runHook preCheck

    trial treq

    runHook postCheck
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/twisted/treq";
    description = "Requests-like API built on top of twisted.web's Agent";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/twisted/treq";
    description = "Requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
