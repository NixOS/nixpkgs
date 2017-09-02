{ stdenv, fetchPypi, buildPythonPackage, service-identity, requests, six
, mock, twisted, incremental, pep8 }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "treq";
  version = "17.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef72d2d5e0b24bdf29267b608fa33df0ac401743af8524438b073e1fb2b66f16";
  };

  propagatedBuildInputs = [ twisted requests six incremental service-identity ];

  checkInputs = [
    pep8
    mock
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

  meta = with stdenv.lib; {
    homepage = http://github.com/twisted/treq;
    description = "A requests-like API built on top of twisted.web's Agent";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
