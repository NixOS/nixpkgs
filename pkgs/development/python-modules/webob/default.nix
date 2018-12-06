{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "WebOb";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10vjp2rvqiyvw157fk3sy7yds1gknzw97z4gk0qv1raskx5s2p76";
  };

  propagatedBuildInputs = [ nose pytest ];

  meta = with stdenv.lib; {
    description = "WSGI request and response object";
    homepage = http://pythonpaste.org/webob/;
    license = licenses.mit;
  };

}
