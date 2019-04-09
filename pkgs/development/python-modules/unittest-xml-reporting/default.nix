{lib, fetchPypi, buildPythonPackage, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "2.4.0";

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qnlz1k77rldgd5dfrj6nhlsjj71xzqy6s4091djpk0s2p8y1550";
  };
  meta = with lib; {
    homepage = https://github.com/xmlrunner/unittest-xml-reporting/tree/master/;
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
