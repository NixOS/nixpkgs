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
  mock,
  zope-testing,
  zope-testrunner,
  python,
}:

buildPythonPackage rec {
  pname = "zope-testbrowser";
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.testbrowser";
    rev = "refs/tags/${version}";
    hash = "sha256-vGx2ObHgt4hSQe/JKZkD2/GhdtbJEAfggkM209maen4=";
  };

  postPatch = ''
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
