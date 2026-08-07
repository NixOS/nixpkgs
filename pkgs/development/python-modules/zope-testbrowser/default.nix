{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
  zope-schema,
  zope-cachedescriptors,
  pytz,
  webtest,
  beautifulsoup4,
  soupsieve,
  wsgiproxy2,
  legacy-cgi,
  mock,
  zope-testing,
  zope-testrunner,
  python,
}:

buildPythonPackage rec {
  pname = "zope-testbrowser";
  version = "8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.testbrowser";
    tag = version;
    hash = "sha256-CcNlK7EKYng0GKYTZ2U2slkyQ9wTqwzOXGHt9S5p3L0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="

    # remove test that requires network access
    substituteInPlace src/zope/testbrowser/tests/test_doctests.py \
      --replace-fail "suite.addTests(wire)" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    zope-interface
    zope-schema
    zope-cachedescriptors
    pytz
    webtest
    beautifulsoup4
    soupsieve
    wsgiproxy2
    legacy-cgi
  ];

  nativeCheckInputs = [
    mock
    zope-testing
    zope-testrunner
  ];

  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src
  '';

  pythonImportsCheck = [
    "zope.testbrowser"
    "zope.testbrowser.browser"
    "zope.testbrowser.interfaces"
    "zope.testbrowser.testing"
    "zope.testbrowser.wsgi"
  ];

  meta = {
    changelog = "https://github.com/zopefoundation/zope.testbrowser/blob/${src.rev}/CHANGES.rst";
    description = "Programmable browser for functional black-box tests";
    homepage = "https://github.com/zopefoundation/zope.testbrowser";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
