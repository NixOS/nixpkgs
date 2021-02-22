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

  disabledTests = [
    # on CPU, these expect artifacts from previous GPU run
    "test_load_cuda_params_to_cpu"
    # failing tests
    "test_pickle_load"
    "test_grid_search_with_slds_"
    "test_grid_search_with_dict_works"
  ];

  meta = with lib; {
    description = "Scikit-learn compatible neural net library using Pytorch";
    homepage = "https://skorch.readthedocs.io";
    changelog = "https://github.com/skorch-dev/skorch/blob/master/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    # TypeError: __init__() got an unexpected keyword argument 'iid'
    broken = true;
  };
}
