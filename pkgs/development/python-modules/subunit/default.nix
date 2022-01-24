{ buildPythonPackage
# pkgs dependencies
, check
, cppunit
, pkg-config
, subunit
, pythonOlder

# python dependencies
, fixtures
, hypothesis
, pytest
, testscenarios
, testtools
, unittest2
}:

buildPythonPackage {
  inherit (subunit) name src meta;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ check cppunit ];
  propagatedBuildInputs = [ testtools ];

  checkInputs = [ testscenarios hypothesis fixtures pytest unittest2 ];

  # requires unittest2, which no longer supported in 3.10
  doCheck = pythonOlder "3.10";
  # ignore tests which call shell code, or call methods which haven't been implemented
  checkPhase = ''
    pytest python/subunit \
      --ignore=python/subunit/tests/test_{output_filter,test_protocol{,2}}.py
  '';

  postPatch = ''
    sed -i 's/version=VERSION/version="${subunit.version}"/' setup.py
  '';
}
