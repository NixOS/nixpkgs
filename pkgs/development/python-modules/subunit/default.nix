{ buildPythonPackage
, pkgs
, python
, testtools
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

  checkInputs = [ python testscenarios ];
  pythonImportsCheck = [ "subunit" ];
  checkPhase = ''
    ${python.interpreter} all_tests.py
  '';

  meta = pkgs.subunit.meta;

}
