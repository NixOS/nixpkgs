{ lib
, buildPythonPackage
, fetchPypi
, certauth
, gevent
, mock
, pytest
, requests
, six
, websocket_client
, waitress
}:

buildPythonPackage rec {
  pname = "wsgiprox";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d0x0ihms5sv9v8nrb65wlih6zcdh0644q6nawkzylmvfpwp2k2c";
  };

  propagatedBuildInputs = [ certauth six ];

  # Don't provide uwsgi to skip tests that would hang on network access.
  checkInputs = [ gevent mock pytest requests websocket_client waitress ];
  checkPhase = ''
    # Based on https://github.com/webrecorder/wsgiprox/blob/master/setup.py
    py.test --doctest-module ./wsgiprox wsgiprox -v test/
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Middleware for adding HTTP/S proxy support to WSGI applications";
    homepage = https://github.com/webrecorder/wsgiprox;
    license = licenses.asl20;
    maintainers = with maintainers; [ ivan ];
  };
}
