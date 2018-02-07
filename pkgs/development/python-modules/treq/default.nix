{ stdenv, fetchPypi, buildPythonPackage, service-identity, requests, six
, mock, twisted, incremental, pep8, httpbin
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "treq";
  version = "17.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef72d2d5e0b24bdf29267b608fa33df0ac401743af8524438b073e1fb2b66f16";
  };

  propagatedBuildInputs = [
    requests
    six
    incremental
    service-identity
    twisted
    # twisted [tls] requirements (we should find a way to list "extras")
    twisted.extras.tls
  ];

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
    homepage = https://github.com/twisted/treq;
    description = "A requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
