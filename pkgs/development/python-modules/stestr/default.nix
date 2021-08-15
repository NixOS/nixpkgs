{ lib, buildPythonPackage, fetchPypi
, future, pbr, cliff, subunit, fixtures, testtools, pyyaml, voluptuous
, pytestCheckHook, ddt }:

buildPythonPackage rec {
  pname = "stestr";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i1b2z44ja8sbkqhaxyxc2xni6m9hky4x0254s0xdzfkyfyjqjgv";
  };

  propagatedBuildInputs = [
    future
    pbr
    cliff
    subunit
    fixtures
    testtools
    pyyaml
    voluptuous
  ];

  checkInputs = [ pytestCheckHook ddt ];
  preCheck = ''
    export PATH=$out/bin:$PATH
    export HOME=$TMPDIR
  '';
  disabledTests = [
    # Broken test
    "test_empty_with_pretty_out"
  ];
  pythonImportsCheck = [ "stestr" ];

  meta = with lib; {
    description = "A parallel Python test runner built around subunit";
    homepage = "https://stestr.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
