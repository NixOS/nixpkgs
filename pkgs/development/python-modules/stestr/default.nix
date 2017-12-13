{ lib
, buildPythonPackage
, fetchPypi
, pbr
, fixtures, testtools
, subunit
, pyyaml
, six, future, ddt
, coverage, mock, sphinx
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xiz8q4yp164gzsxigb24cz9v6klmg2axm8hphjkh6zhnp7538fs";
  };

  propagatedBuildInputs = [
    pbr
    subunit
    fixtures
    six
    testtools
    pyyaml
    future
  ];

  # subunit2sql is not packaged, hacking is not packaged
  doCheck = false;
  checkInputs = [
    # hacking
    # subunit2sql
    sphinx
    mock
    coverage
    ddt
  ];

  meta = with lib;{
    description = "A parallel Python test runner built around subunit";
    homepage = http://stestr.readthedocs.io/en/latest/;
    license = licenses.asl20;
  };

}
