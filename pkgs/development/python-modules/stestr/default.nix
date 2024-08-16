{
  lib,
  buildPythonPackage,
  fetchPypi,
  cliff,
  fixtures,
  future,
  pbr,
  setuptools,
  subunit,
  testtools,
  tomlkit,
  voluptuous,
  callPackage,
}:

buildPythonPackage rec {
  pname = "stestr";
  version = "4.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X2HDae7OY8KS0TWZ4SqhWK92hZkGQ/JN1vp/q/406Yo=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    cliff
    fixtures
    future
    pbr
    subunit
    testtools
    tomlkit
    voluptuous
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "stestr" ];

  meta = with lib; {
    description = "Parallel Python test runner built around subunit";
    mainProgram = "stestr";
    homepage = "https://github.com/mtreinish/stestr";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
