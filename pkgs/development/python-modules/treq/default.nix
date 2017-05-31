{ stdenv, fetchPypi, buildPythonPackage, service-identity, requests, six,
  mock, twisted, incremental, pep8, sphinx, openssl, pyopenssl, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "treq";
  version = "17.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xhcpvsl3xqw0dq9sixk80iwyiv17djigp3815sy5pfgvvggcfii";
  };

  buildInputs = [
    service-identity
    requests
    twisted
    incremental
    sphinx
    six
    openssl
    pyopenssl
    tox
  ];

  checkInputs = [
    pep8
    mock
  ];

  postPatch = ''
    rm -fv src/treq/test/test_treq_integration.py
  '';

  postBuild = ''
    # build documentation and install in $out
    tox -e docs
    mkdir -pv $out/docs
    cp -rv docs/* $out/docs/
  '';

  checkPhase = ''
    ${pep8}/bin/pep8 --ignore=E902 treq
    trial treq
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/twisted/treq;
    description = "A requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
