{lib, fetchPypi, buildPythonPackage, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "2.5.2";

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d28ddf6524cf0ff9293f61bd12e792de298f8561a5c945acea63fb437789e0e";
  };
  meta = with lib; {
    homepage = https://github.com/xmlrunner/unittest-xml-reporting/tree/master/;
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
