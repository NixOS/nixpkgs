{ buildPythonPackage
, pkgs
, testtools
  # Check Inputs
, fixtures
, hypothesis
, pytest
, python
, testscenarios
}:

buildPythonPackage {
  name = pkgs.subunit.name;
  src = pkgs.subunit.src;

  propagatedBuildInputs = [ testtools ];
  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ pkgs.check pkgs.cppunit ];

  patchPhase = ''
    sed -i 's/version=VERSION/version="${pkgs.subunit.version}"/' setup.py
  '';

  checkInputs = [ fixtures hypothesis pytest python testscenarios ];
  pythonImportsCheck = [ "subunit" ];
  checkPhase = ''
    # Not very necessary. This test isn't actually currently run
    substituteInPlace python/iso8601/test_iso8601.py --replace "import iso8601" "import subunit.iso8601 as iso8601"

    ${python.interpreter} -m unittest all_tests.py # theoretically this should run all tests, but doesn't work. /bin/sh can't source paths
    pytest --pyargs subunit.tests # This has ~30 fails, most down to some classes missing "option" attribute.
  '';

  meta = pkgs.subunit.meta;

}
