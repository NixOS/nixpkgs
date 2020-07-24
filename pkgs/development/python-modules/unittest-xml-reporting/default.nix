{lib, fetchPypi, buildPythonPackage, isPy27, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "3.0.2";
  disabled = isPy27;

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e09b8ae70cce9904cdd331f53bf929150962869a5324ab7ff3dd6c8b87e01f7d";
  };
  meta = with lib; {
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting/tree/master/";
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
