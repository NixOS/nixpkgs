{ lib
, stdenv
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
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/d0s0N40W18uGfVbD9VEbhbWfduoo+TBqDjmTkjMUxs=";
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
  ] ++ lib.optionals stdenv.isDarwin [
    # there is a problem with the compiler selection
    "test_fit_and_predict_with_compile"
  ];

  disabledTestPaths = [
    # tries to import `transformers` and download HuggingFace data
    "skorch/tests/test_hf.py"
  ] ++ lib.optionals (stdenv.hostPlatform.system != "x86_64-linux") [
    # torch.distributed is disabled by default in darwin
    # aarch64-linux also failed these tests
    "skorch/tests/test_history.py"
  ];

  pythonImportsCheck = [ "skorch" ];

  meta = with lib; {
    description = "Scikit-learn compatible neural net library using Pytorch";
    homepage = "https://skorch.readthedocs.io";
    changelog = "https://github.com/skorch-dev/skorch/blob/master/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
