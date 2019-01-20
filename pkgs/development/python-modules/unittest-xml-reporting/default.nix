{lib, fetchPypi, buildPythonPackage, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "2.2.1";

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cn870jgf4h0wb4bnafw527g1dj6rd3rgyjz4f64khd0zx9qs84z";
  };
  meta = with lib; {
    homepage = https://github.com/xmlrunner/unittest-xml-reporting/tree/master/;
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
