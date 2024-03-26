{ lib
, buildPythonPackage
, cirq-core
, fetchFromGitHub
, matplotlib
, networkx
, numpy
, pandas
, pybind11
, pytest-xdist
, pytestCheckHook
, pythonOlder
, scipy
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "stim";
  version = "1.13.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "Stim";
    rev = "refs/tags/v${version}";
    hash = "sha256-anJvDHLZ470iNw0U7hq9xGBacDgqYO9ZcmmdCt9pefg=";
  };

  postPatch = ''
    # asked to relax this in https://github.com/quantumlib/Stim/issues/623
    substituteInPlace pyproject.toml \
      --replace "pybind11==" "pybind11>="
  '';

  nativeBuildInputs = [
    pybind11
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    cirq-core
    matplotlib
    networkx
    pandas
    pytest-xdist
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [
    "stim"
  ];

  enableParallelBuilding = true;

  disabledTestPaths = [
    # Don't test sample
    "glue/sample/"
  ];

  meta = with lib; {
    description = "A tool for high performance simulation and analysis of quantum stabilizer circuits, especially quantum error correction (QEC) circuits";
    mainProgram = "stim";
    homepage = "https://github.com/quantumlib/stim";
    changelog = "https://github.com/quantumlib/Stim/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ chrispattison ];
  };
}
