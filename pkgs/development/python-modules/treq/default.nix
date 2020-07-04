{ stdenv, fetchPypi, buildPythonPackage, service-identity, requests, six
, mock, twisted, incremental, pep8, httpbin
}:

buildPythonPackage rec {
  pname = "treq";
  version = "20.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "115wwb3sripl3xvwpygwyrxrapyis0i7w1yq591z3dwl9k9fgzk8";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/twisted/treq";
    description = "A requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
