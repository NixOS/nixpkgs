{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, flaky
, numpy
, pandas
, torch
, scikit-learn
, scipy
, tabulate
, tqdm
}:

buildPythonPackage rec {
  pname = "skorch";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fjNbNY/Dr7lgVGPrHJTvPGuhyPR6IVS7ohBQMI+J1+k=";
  };

  propagatedBuildInputs = [ numpy torch scikit-learn scipy tabulate tqdm ];
  nativeCheckInputs = [ flaky pandas pytestCheckHook ];

  # patch out pytest-cov dep/invocation
  postPatch = ''
    substituteInPlace setup.cfg  \
      --replace "--cov=skorch" ""  \
      --replace "--cov-report=term-missing" ""  \
      --replace "--cov-config .coveragerc" ""
  '';

  disabledTests = [
    # on CPU, these expect artifacts from previous GPU run
    "test_load_cuda_params_to_cpu"
    # failing tests
    "test_pickle_load"
  ];

  # tries to import `transformers` and download HuggingFace data
  disabledTestPaths = [ "skorch/tests/test_hf.py" ];

  pythonImportsCheck = [ "skorch" ];

  meta = with lib; {
    description = "Scikit-learn compatible neural net library using Pytorch";
    homepage = "https://skorch.readthedocs.io";
    changelog = "https://github.com/skorch-dev/skorch/blob/master/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
