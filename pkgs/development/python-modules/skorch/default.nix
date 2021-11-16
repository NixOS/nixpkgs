{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest
, pytest-cov
, flaky
, numpy
, pandas
, pytorch
, scikit-learn
, scipy
, tabulate
, tqdm
}:

buildPythonPackage rec {
  pname = "skorch";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b35cb4e50045742f0ffcfad33044af691d5d36b50212573753a804483a947ca9";
  };

  propagatedBuildInputs = [ numpy pytorch scikit-learn scipy tabulate tqdm ];
  checkInputs = [ pytest pytest-cov flaky pandas pytestCheckHook ];

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
