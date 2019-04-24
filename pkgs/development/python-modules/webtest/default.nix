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
}:

buildPythonPackage rec {
  version = "2.0.32";
  pname = "webtest";

  src = fetchPypi {
    pname = "WebTest";
    inherit version;
    sha256 = "4221020d502ff414c5fba83c1213985b83219cb1cc611fe58aa4feaf96b5e062";
  };

  preConfigure = ''
    substituteInPlace setup.py --replace "nose<1.3.0" "nose"
  '';

  propagatedBuildInputs = [ webob six beautifulsoup4 waitress ];

  checkInputs = [ nose mock PasteDeploy wsgiproxy2 pyquery ];

  meta = with stdenv.lib; {
    description = "Helper to test WSGI applications";
    homepage = https://webtest.readthedocs.org/en/latest/;
    license = licenses.mit;
  };

}
