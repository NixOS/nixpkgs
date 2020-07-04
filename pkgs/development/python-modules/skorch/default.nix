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
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l576dws9drjakfsn0pfpbr48b21vpxv3vd3dz8lkbn8q71zs22r";
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
