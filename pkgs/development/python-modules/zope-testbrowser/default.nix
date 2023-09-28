{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, zope_interface
, zope_schema
, zope-cachedescriptors
, pytz
, webtest
, beautifulsoup4
, soupsieve
, wsgiproxy2
, six
, mock
, zope_testing
, zope_testrunner
, python
}:

buildPythonPackage rec {
  pname = "zope-testbrowser";
  version = "6.0";

  format = "setuptools";

  src = fetchPypi {
    pname = "zope.testbrowser";
    inherit version;
    sha256 = "sha256-RLd6XpA3q+3DZHai6j3H6XTWE85Sk913zAL4iO4x+ho=";
  };

  postPatch = ''
    # remove test that requires network access
    substituteInPlace src/zope/testbrowser/tests/test_doctests.py \
      --replace "suite.addTests(wire)" ""
  '';

  propagatedBuildInputs = [
    setuptools
    zope_interface
    zope_schema
    zope-cachedescriptors
    pytz
    webtest
    beautifulsoup4
    soupsieve
    wsgiproxy2
    six
  ];

  nativeCheckInputs = [
    mock
    zope_testing
    zope_testrunner
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
    description = "Programmable browser for functional black-box tests";
    homepage = "https://github.com/zopefoundation/zope.testbrowser";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
