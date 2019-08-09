{lib, fetchPypi, buildPythonPackage, six}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "2.5.1";

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v6xcs8nx82yw037h296zk0vz5ka4idm4xdpxkcm4h4fnpj8428l";
  };
  meta = with lib; {
    homepage = https://github.com/xmlrunner/unittest-xml-reporting/tree/master/;
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
