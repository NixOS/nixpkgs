{ lib, fetchPypi, buildPythonPackage, service-identity, requests, six
, mock, twisted, incremental, pep8, httpbin
}:

buildPythonPackage rec {
  pname = "treq";
  version = "21.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fdae0c872c444ed96c3cb11be8445d22e4afb731e87fdddae3b00c609e77199f";
  };

  propagatedBuildInputs = [
    requests
    six
    incremental
    service-identity
    twisted
  ]
    # twisted [tls] requirements (we should find a way to list "extras")
    ++ twisted.extras.tls;

  checkInputs = [
    pep8
    mock
    httpbin
  ];

  postPatch = ''
    rm -fv src/treq/test/test_treq_integration.py
  '';

  # XXX tox tries to install coverage despite it is installed
  #postBuild = ''
  #  # build documentation and install in $out
  #  tox -e docs
  #  mkdir -pv $out/docs
  #  cp -rv docs/* $out/docs/
  #'';

  checkPhase = ''
    pep8 --ignore=E902 treq
    trial treq
  '';

  # Failing tests https://github.com/twisted/treq/issues/208
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/twisted/treq";
    description = "A requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
