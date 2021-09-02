{ lib, buildPythonPackage, fetchPypi
, setuptools, zope_testing, martian, six
, zope_component
}:

buildPythonPackage rec {
  pname = "z3c_testsetup";
  version = "0.8.4";

  src = fetchPypi {
    pname = "z3c.testsetup";
    inherit version;
    sha256 = "f44b09c7fea54dcd37661f8926dd59a987562e9eab999745be3377300cacf6fb";
  };

  propagatedBuildInputs = [
    setuptools
    zope_testing
    martian
    six
  ];

  checkInputs = [
    #zope.app.testing # Missing dependency
    #zope.app.zcmlfiles # Missing dependency
    zope_component
  ];
  doCheck = false;

  pythonImportsCheck = [ "z3c.testsetup" ];

  meta = with lib; {
    description = "Easier test setup for Zope 3 projects and other Python packages";
    downloadPage = "https://pypi.org/project/z3c.testsetup/";
    homepage = "https://github.com/zopefoundation/z3c.testsetup";
    license = licenses.zpl21;
    maintainers = with maintainers; [ superherointj ];
  };
}
