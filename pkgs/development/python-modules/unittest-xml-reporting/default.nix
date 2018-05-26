{lib, fetchPypi, buildPythonPackage, six}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "unittest-xml-reporting";
  version = "2.1.1";

  propagatedBuildInputs = [six];

  # The tarball from Pypi doesn't actually contain the unit tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jwkqx5gfphkymp3xwqvlb94ng22gpbqh36vbbnsrpk1a0mammm6";
  };
  meta = with lib; {
    homepage = https://github.com/xmlrunner/unittest-xml-reporting/tree/master/;
    description = "A unittest runner that can save test results to XML files";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
