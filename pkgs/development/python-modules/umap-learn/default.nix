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
, pythonRelaxDepsHook
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
    # Fix tests with numpy>=1.24
    # https://github.com/lmcinnes/umap/pull/952
    (fetchpatch {
      url = "https://github.com/lmcinnes/umap/commit/588e1f724c9f5de528eb1500b0c85a1a609fe947.patch";
      hash = "sha256-B50eyMs3CRuzOAq+jxz56XMJPdiUofUxCL0Vqolaafo=";
    })
    # https://github.com/lmcinnes/umap/pull/1010
    (fetchpatch {
      url = "https://github.com/lmcinnes/umap/commit/848396c762c894e666aaf3d0bcfe1e041b529ea6.patch";
      hash = "sha256-ir0Pxfr2c0oSuFGXQqHjkj7nzvlpTXCYbaI9qAiLun0=";
    })
    (fetchpatch {
      url = "https://github.com/lmcinnes/umap/commit/30e39938f4627f327223245dfe2c908af6b7e304.patch";
      hash = "sha256-7Divrym05wIPa7evgrNYXGm44/EOWG8sIYV8fmtuzJ4=";
    })
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    # the version of numba may not be set correctly until the next release, 0.58
    # see the comment of https://github.com/NixOS/nixpkgs/pull/247678
    "numba"
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

    # incompatible with numpy 1.25
    "test_tsw_spectral_init"
    # incompatible with scipy 1.11
    "test_kulsinski"
    "test_sparse_kulsinski"
    # incompatible with sklearn 1.3
    "test_composite_trustworthiness"
    "test_multi_component_layout"
    "test_multi_component_layout_precomputed"
    "test_precomputed_knn_on_iris"
  ];

  meta = with lib; {
    description = "Uniform Manifold Approximation and Projection";
    homepage = "https://github.com/lmcinnes/umap";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
