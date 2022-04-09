{lib, fetchPypi, buildPythonPackage, isPy27, six, lxml }:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "3.2.0";
  disabled = isPy27;

  propagatedBuildInputs = [
    lxml
    six
  ];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7djTFwtAw6gbjPkQ9GxqMErihH7AEDbQLpwPm4V2LSg=";
  };
  meta = with lib; {
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting/tree/master/";
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
