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
  version = "5.6.1";

  format = "setuptools";

  src = fetchPypi {
    pname = "zope.testbrowser";
    inherit version;
    sha256 = "035bf63d9f7244e885786c3327448a7d9fff521dba596429698b8474961b05e7";
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
