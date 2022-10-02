{ lib
, pkgs
, buildPythonPackage
, pythonOlder
, pytestCheckHook
, pytest-xdist
, fetchFromGitHub
, numpy
, pybind11
, cirq-core
, matplotlib
, networkx
, scipy
, pandas
}:

buildPythonPackage rec {
  pname = "stim";
  version = "1.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = pkgs.fetchFromGitHub {
    owner = "quantumlib";
    repo = "Stim";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zXWdJjFkf74FCWxyVMF8dx0P8GmUkuHFxUo5wYNU2o0=";
  };

  propagatedBuildInputs = [
    numpy
    pybind11
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist

    cirq-core
    matplotlib
    networkx
    scipy
    pandas
  ];

  meta = {
    description = "A tool for high performance simulation and analysis of quantum stabilizer circuits, especially quantum error correction (QEC) circuits.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chrispattison ];
    homepage = "https://github.com/quantumlib/stim";
  };

  pythonImportsCheck = [ "stim" ];

  enableParallelBuilding = true;

  disabledTestPaths = [
    # No pymatching
    "glue/sample/src/sinter/main_test.py"
    "glue/sample/src/sinter/decoding_test.py"
    "glue/sample/src/sinter/predict_test.py"
    "glue/sample/src/sinter/collection_test.py"
    "glue/sample/src/sinter/collection_work_manager.py"
    "glue/sample/src/sinter/worker_test.py"
  ];
}
