{ lib
, buildPythonPackage
, fetchPypi
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "WebOb";
  version = "1.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b64ef5141be559cfade448f044fa45c2260351edcb6a8ef6b7e00c7dcef0c323";
  };

  propagatedBuildInputs = [ nose pytest ];

  meta = with lib; {
    description = "WSGI request and response object";
    homepage = "http://pythonpaste.org/webob/";
    license = licenses.mit;
  };

}
