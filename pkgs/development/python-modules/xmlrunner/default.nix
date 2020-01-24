{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "xmlrunner";
  version = "1.7.7";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "5a6113d049eca7646111ee657266966e5bbfb0b5ceb2e83ee0772e16d7110f39";
  };
  
  # No test is implemented for this package
  doCheck = false;
  
  meta = with lib; {
    description = "PyUnit-based test runner with JUnit like XML reporting";
    homepage = "https://github.com/pycontribs/xmlrunner";
    license = licenses.lgpl2;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
