{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, git, asyncio
, cherrypy, gevent, tornado }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ws4py";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee12b58384bab8bfdcd1c76dcd6852047aec163af17175fc0f73e255d107dd7a";
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
