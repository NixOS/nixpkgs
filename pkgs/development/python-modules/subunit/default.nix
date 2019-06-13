{ buildPythonPackage
, pkgs
, testtools
, testscenarios
}:

buildPythonPackage rec {
  name = pkgs.subunit.name;
  src = pkgs.subunit.src;

  propagatedBuildInputs = [ testtools ];
  checkInputs = [ testscenarios ];
  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ pkgs.check pkgs.cppunit ];

  patchPhase = ''
    sed -i 's/version=VERSION/version="${pkgs.subunit.version}"/' setup.py
  '';

  meta = pkgs.subunit.meta;

}
