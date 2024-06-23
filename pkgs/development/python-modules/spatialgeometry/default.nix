{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  oldest-supported-numpy,
  setuptools,
  spatialmath-python,
  pybullet,
  black,
  flake8,
  pytest,
  pytest-cov,
  pyyaml,
  callPackage,
}:

buildPythonPackage rec {
  pname = "spatialgeometry";
  version = "1.1.0";
  pyproject = true;

  outputs = [
    "out"
    "testsout"
  ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mLKxAj7tYZfSbzHPRkPFHRpBBZrGA2oQsW3Diexq9aY=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
  ];

  propagatedBuildInputs = [ spatialmath-python ];

  passthru.optional-dependencies = {
    collision = [ pybullet ];
    dev = [
      black
      flake8
      pytest
      pytest-cov
      pyyaml
    ];
  };

  postInstall = ''
    mkdir $testsout
    cp -R tests $testsout/tests
  '';

  # Tests have been put in their own derivation as there is a circular
  # dependency between spatialgeometry and roboticstoolbox-python. Check in
  # passthru.tests.pytest for the tests.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "spatialgeometry" ];

  meta = with lib; {
    description = "A Shape and Geometry Description Package";
    homepage = "https://pypi.org/project/spatialgeometry/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
