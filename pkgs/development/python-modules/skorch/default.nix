{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest
, pytestcov
, flaky
, numpy
, pandas
, pytorch
, scikitlearn
, scipy
, tabulate
, tqdm
}:

buildPythonPackage rec {
  pname = "skorch";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bdce9370153fd80c5c4ec499a639f55eef0620e45d4b15fbf7d7ff2a225a3d40";
  };

  propagatedBuildInputs = [ numpy pytorch scikitlearn scipy tabulate tqdm ];
  checkInputs = [ pytest pytestcov flaky pandas pytestCheckHook ];

  # on CPU, these expect artifacts from previous GPU run
  disabledTests = [
    "test_load_cuda_params_to_cpu"
    "test_pickle_load"
  ];

  meta = with lib; {
    description = "Scikit-learn compatible neural net library using Pytorch";
    homepage = "https://skorch.readthedocs.io";
    changelog = "https://github.com/skorch-dev/skorch/blob/master/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
