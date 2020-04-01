{ buildPythonPackage
# pkgs dependencies
, check
, cppunit
, pkg-config
, subunit

# python dependencies
, fixtures
, hypothesis
, pytest
, testscenarios
, testtools
}:

buildPythonPackage {
  inherit (subunit) name src meta;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ check cppunit ];
  propagatedBuildInputs = [ testtools ];

  checkInputs = [ testscenarios hypothesis fixtures pytest ];
  # ignore tests which call shell code, or call methods which haven't been implemented
  checkPhase = ''
    pytest python/subunit \
      --ignore=python/subunit/tests/test_{output_filter,test_protocol{,2}}.py
  '';

  patchPhase = ''
    sed -i 's/version=VERSION/version="${subunit.version}"/' setup.py
  '';
}
