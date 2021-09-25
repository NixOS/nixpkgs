{ lib
, buildPythonPackage
, fetchPypi
, cliff
, fixtures
, future
, pbr
, subunit
, testtools
, voluptuous
, callPackage
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb492cbdf3d3fdd6812645804efc84a99a68bb60dd7705f15c1a2949c8172bc4";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  propagatedBuildInputs = [
    cliff
    fixtures
    future
    pbr
    subunit
    testtools
    voluptuous
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "stestr" ];

  meta = with lib; {
    description = "A parallel Python test runner built around subunit";
    homepage = "https://github.com/mtreinish/stestr";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
