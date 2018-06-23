{lib, fetchPypi, buildPythonPackage, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "2.2.0";

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ba27af788bddb4403ee72561bfd3df2deb27a926a5426aa9beeb354c59b9c44";
  };
  meta = with lib; {
    homepage = https://github.com/xmlrunner/unittest-xml-reporting/tree/master/;
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
