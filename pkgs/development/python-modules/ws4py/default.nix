{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, git, asyncio
, cherrypy, gevent, tornado }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ws4py";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zr3254ky6r7q15l3dhdczfa8i723055zdkqssjifsgcwvirriks";
  };

  checkInputs = [ pytest mock git ];
  propagatedBuildInputs = [ asyncio cherrypy gevent tornado ];

  checkPhase = ''
    pytest -k 'not test_timeout_when_no_registered_fds and not test_mainloop_can_be_stopped_when_no_websocket_were_registered'
  '';

  meta = with stdenv.lib; {
    homepage = https://ws4py.readthedocs.org;
    description = "A WebSocket package for Python";
    maintainers = with maintainers; [ rickynils ];
  };
}
