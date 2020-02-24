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
    export SHELL_SHARE=./shell/share/
    patchShebangs ./shell/tests/*.sh
    # this SHOULD run all tests in python/subunit/tests, but only runs ./shell/tests/*
    ${python.interpreter} -m unittest all_tests.py

    # Use pyargs b/c tests are in site-packages/subunit/tests/...
    # This has ~30 fails, most down to some classes missing "option" attribute. Don't know cause of others
    pytest --pyargs subunit.tests
  '';

  meta = pkgs.subunit.meta;

}
