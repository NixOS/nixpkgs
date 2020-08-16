{lib, fetchPypi, buildPythonPackage, isPy27, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "3.0.3";
  disabled = isPy27;

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "89ad3376cc63dc0f7227c1e39d03d5f6a20807fef989c57d8c623446b5f79575";
  };
  meta = with lib; {
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting/tree/master/";
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
