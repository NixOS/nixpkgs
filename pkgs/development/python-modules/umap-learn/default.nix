{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, keras
, numba
, numpy
, pynndescent
, pytestCheckHook
, pythonOlder
, scikit-learn
, scipy
, tensorflow
, tqdm
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    hash = "sha256-S2+k7Ec4AxsN6d0GUGnU81oLnBgmlZp8OmUFCNaUJYw=";
  };

  patches = [
    # Fix tests with sklearn>=1.2.0
    (fetchpatch {
      url = "https://github.com/lmcinnes/umap/commit/a714b59bd9e2ca2e63312bc3491b2b037a42f2f2.patch";
      hash = "sha256-WOSWNN5ewVTV7IEBEA7ZzgZYMZxctF1jAWs9ylKTyLs=";
    })
    (fetchpatch {
      url = "https://github.com/lmcinnes/umap/commit/c7d05683325589ad432a55e109cacb9d631cfaa9.patch";
      hash = "sha256-hE2Svxf7Uja+DbCmTDCnd7mZynjNbC5GUjfqg4ZRO9Y=";
    })
    (fetchpatch {
      url = "https://github.com/lmcinnes/umap/commit/949abd082524fce8c45dfb147bcd8e8ef49eade3.patch";
      hash = "sha256-8/1k8iYeF77FIaUApNtY07auPJkrt3vNRR/HTYRvq+0=";
    })
  ];

  propagatedBuildInputs = [
    numba
    numpy
    pynndescent
    scikit-learn
    scipy
    tqdm
  ];

  nativeCheckInputs = [
    keras
    pytestCheckHook
    tensorflow
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Plot functionality requires additional packages.
    # These test also fail with 'RuntimeError: cannot cache function' error.
    "test_umap_plot_testability"
    "test_plot_runs_at_all"

    # Flaky test. Fails with AssertionError sometimes.
    "test_sparse_hellinger"
    "test_densmap_trustworthiness_on_iris_supervised"

    # tensorflow maybe incompatible? https://github.com/lmcinnes/umap/issues/821
    "test_save_load"
  ];

  meta = with lib; {
    description = "Uniform Manifold Approximation and Projection";
    homepage = "https://github.com/lmcinnes/umap";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
