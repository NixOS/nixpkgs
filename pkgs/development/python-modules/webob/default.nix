{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "WebOb";
  version = "1.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05aaab7975e0ee8af2026325d656e5ce14a71f1883c52276181821d6d5bf7086";
  };

  propagatedBuildInputs = [ nose pytest ];

  meta = with stdenv.lib; {
    description = "WSGI request and response object";
    homepage = http://pythonpaste.org/webob/;
    license = licenses.mit;
  };

}
