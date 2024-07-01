{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  oldest-supported-numpy,
  setuptools,
  numpy,
  spatialgeometry,
  websockets,
  black,
  flake8,
  pytest,
  pytest-cov,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "swift-sim";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d6mTSEGe0sqFT2leEyjlwxOi/axhLtSyQG4lUd4U99A=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    spatialgeometry
    websockets
  ];

  passthru.optional-dependencies = {
    dev = [
      black
      flake8
      pytest
      pytest-cov
      pyyaml
    ];
  };

  pythonImportsCheck = [ "swift" ];

  meta = with lib; {
    description = "A Python/Javascript Robot Simulator and Visualiser";
    homepage = "https://pypi.org/project/swift-sim/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
