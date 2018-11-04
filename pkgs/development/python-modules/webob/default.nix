{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "WebOb";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0853dad347ca3777755b6d0659bb45efbeea71f995d8a395291ef6ad5d4f8b2";
  };

  propagatedBuildInputs = [ nose pytest ];

  meta = with stdenv.lib; {
    description = "WSGI request and response object";
    homepage = http://pythonpaste.org/webob/;
    license = licenses.mit;
  };

}
