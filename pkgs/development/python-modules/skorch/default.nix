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
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9910f97339e654c8d38e0075d87b735e69e5eb11db59c527fb36705b30c8d0a4";
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
