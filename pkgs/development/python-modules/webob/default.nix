{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "WebOb";
  version = "1.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa3a917ed752ba3e0b242234b2a373f9c4e2a75d35291dcbe977649bd21fd108";
  };

  propagatedBuildInputs = [ nose pytest ];

  meta = with stdenv.lib; {
    description = "WSGI request and response object";
    homepage = "http://pythonpaste.org/webob/";
    license = licenses.mit;
  };

}
