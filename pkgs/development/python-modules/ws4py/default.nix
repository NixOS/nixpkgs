{ lib, buildPythonPackage, fetchPypi, pytest, mock, git
, cherrypy, gevent, tornado }:

buildPythonPackage rec {
  pname = "ws4py";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29d073d7f2e006373e6a848b1d00951a1107eb81f3742952be905429dc5a5483";
  };

  nativeCheckInputs = [ pytest mock git ];
  propagatedBuildInputs = [ cherrypy gevent tornado ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://ws4py.readthedocs.org";
    description = "A WebSocket package for Python";
    maintainers = [];
    license = licenses.bsd3;
  };
}
