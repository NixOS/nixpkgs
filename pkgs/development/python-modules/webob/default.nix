{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "WebOb";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a48315158db05df0c47fbdd061b57ba0ba85bdd0b6ea9dca87511b4b7c798e99";
  };

  propagatedBuildInputs = [ nose pytest ];

  meta = with stdenv.lib; {
    description = "WSGI request and response object";
    homepage = http://pythonpaste.org/webob/;
    license = licenses.mit;
  };

}
