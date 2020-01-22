{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, cliff
, fixtures
, future
, pbr
, pythonSubunit
, pyyaml
, six
, testtools
, voluptuous
  # check inputs
, doc8
, ddt
, coverage
, sphinx
, pytest
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "2.6.0";

  # setup versioning requires either sdist tarball or upstream git access.
  # So forced to use pre-built sdist from Pypi, but fine b/c tests included.
  src = fetchPypi {
    inherit pname version;
    sha256 = "040ryqdml2x2klf8l1alsg0jg79s7s6rsz9w9v7mwa183mq5qjnn";
  };

  propagatedBuildInputs = [
    cliff
    fixtures
    future
    pbr
    pythonSubunit
    pyyaml
    six
    testtools
    voluptuous
  ];

  # remove test requirements that aren't in Nix.
  prePatch = ''
    substituteInPlace test-requirements.txt --replace "subunit2sql>=1.8.0" "" --replace "hacking<1.2.0,>=1.1.0" ""
  '';

  checkInputs = [
    coverage  # "needed" for checking (in test-requirements.txt), though not used
    doc8
    ddt
    pytest
    sphinx
  ];
  pythonCheckImports = [ "stestr" ];
  checkPhase = ''
    export PATH=$out/bin:$PATH  # add stestr to path
    export HOME=$(mktemp -d)    # some tests require home for tempfiles
    stestr init # for test_load.py
    pytest \
      --ignore-glob='**/test_sql.py'  # requires subunit2sql
  '';

  meta = with lib; {
    description = "A parallel Python test runner built around subunit";
    homepage = "https://github.com/mtreinish/stestr" ;
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}