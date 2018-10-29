{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, webob
, six
, beautifulsoup4
, waitress
, mock
, pyquery
, wsgiproxy2
, PasteDeploy
, coverage
}:

buildPythonPackage rec {
  version = "2.0.20";
  pname = "webtest";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bv0qhdjakdsdgj4sk21gnpp8xp8bga4x03p6gjb83ihrsb7n4xv";
  };

  preConfigure = ''
    substituteInPlace setup.py --replace "nose<1.3.0" "nose"
  '';

  propagatedBuildInputs = [ nose webob six beautifulsoup4 waitress mock pyquery wsgiproxy2 PasteDeploy coverage ];

  meta = with stdenv.lib; {
    description = "Helper to test WSGI applications";
    homepage = http://webtest.readthedocs.org/en/latest/;
    license = licenses.mit;
  };

}
