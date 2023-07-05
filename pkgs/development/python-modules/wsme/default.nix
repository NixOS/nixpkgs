{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, pbr
, six
, simplegeneric
, netaddr
, pytz
, webob
# Test inputs
, cherrypy
, flask
, flask-restful
, glibcLocales
, nose
, pecan
, sphinx
, transaction
, webtest
}:

buildPythonPackage rec {
  pname = "wsme";
  version = "0.11.0";

  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    pname = "WSME";
    inherit version;
    sha256 = "bd2dfc715bedcc8f4649611bc0c8a238f483dc01cff7102bc1efa6bea207b64b";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    netaddr
    pytz
    simplegeneric
    six
    webob
  ];

  nativeCheckInputs = [
    nose
    cherrypy
    flask
    flask-restful
    glibcLocales
    pecan
    sphinx
    transaction
    webtest
  ];

  # from tox.ini, tests don't work with pytest
  checkPhase = ''
    nosetests wsme/tests tests/pecantest tests/test_sphinxext.py tests/test_flask.py --verbose
  '';

  meta = with lib; {
    description = "Simplify the writing of REST APIs, and extend them with additional protocols";
    homepage = "https://pythonhosted.org/WSME/";
    changelog = "https://pythonhosted.org/WSME/changes.html";
    license = licenses.mit;
  };
}
