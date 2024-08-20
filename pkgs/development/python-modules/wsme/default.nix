{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  pbr,
  setuptools,
  six,
  simplegeneric,
  netaddr,
  pytz,
  webob,
  # Test inputs
  cherrypy,
  flask,
  flask-restful,
  glibcLocales,
  nose,
  pecan,
  sphinx,
  transaction,
  webtest,
}:

buildPythonPackage rec {
  pname = "wsme";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    pname = "WSME";
    inherit version;
    hash = "sha256-m36yJErzxwSskUte0iGVS7aK3QqLKy84okSwZ7M3mS0=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

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
