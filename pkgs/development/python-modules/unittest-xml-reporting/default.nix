{lib, fetchPypi, buildPythonPackage, isPy27, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "3.0.4";
  disabled = isPy27;

  requiredPythonModules = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "984cebba69e889401bfe3adb9088ca376b3a1f923f0590d005126c1bffd1a695";
  };
  meta = with lib; {
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting/tree/master/";
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
