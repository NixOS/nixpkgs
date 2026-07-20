{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python,
  cython,
  joblib,
  lapack,
  nilearn,
  numpy,
  scikit-learn,
  scipy,
  seaborn,
  tabulate,
  nix-update-script,
  pytestCheckHook,
  flaky,
}:

buildPythonPackage (finalAttrs: {
  pname = "skggm";
  version = "0.2.8-unstable-2025-06-14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "skggm";
    repo = "skggm";
    rev = "6792fe7d0079bb7c62e701921e37782a209234cb";
    hash = "sha256-+9XxvmcWo4GMv4n+/NV/3J+pQbMkktEoy5U1c19DsEg=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail "numpy>=1.12.1, <2.0" "numpy>=1.12.1" \
      --replace-fail "scikit-learn>=1.1.13" "scikit-learn>=1.1.3" \
      --replace-fail "pytest>=2.9.2" "" \
      --replace-fail "nose>=1.3.6" "" \
      --replace-fail "tabulate==0.7.5" "tabulate>=0.7.5"

    substituteInPlace setup.cfg \
      --replace-fail "description-file = README.md" "description_file = README.md"

  ''
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace setup.py \
      --replace-fail "'-msse2', " ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cython
    joblib
    lapack
    nilearn
    numpy
    scikit-learn
    scipy
    seaborn
    tabulate
  ];

  # Run tests against the installed package, including the compiled pyquic
  # extension, by copying the installed package and source tests into a
  # temporary merged tree.
  #
  # Several upstream test modules are incompatible with modern scikit-learn
  # (>=1.8) and fail at import/collection time. In particular they still do
  # `from sklearn.utils._testing import assert_raises`, which was removed
  # upstream. skggm has not been updated for this, so the affected
  # test files are disabled

  nativeCheckInputs = [
    pytestCheckHook
    flaky
  ];

  preCheck = ''
    sitePackages=$(echo "$out"/${python.sitePackages})
    testRoot="$TMPDIR/test-root"

    mkdir -p "$testRoot"
    cp -r "$sitePackages/inverse_covariance" "$testRoot/"
    cp -r inverse_covariance/tests "$testRoot/tests"
    cp -r inverse_covariance/profiling/tests "$testRoot/profiling-tests"
    chmod -R +w "$testRoot"

    export PYTHONPATH="$testRoot:$PYTHONPATH"
    cd "$testRoot"
  '';

  enabledTests = [
    "tests"
    "profiling-tests"
  ];

  disabledTestPaths = [
    "tests/quic_graph_lasso_test.py"
    "tests/adaptive_graph_lasso_test.py"
    "tests/common_test.py"
    "tests/model_average_test.py"
    "profiling-tests/monte_carlo_profile_test.py"
  ];

  disabledTests = [
    "integration_quic_graphical_lasso_ebic"
    "test_has_approx_support"
  ];

  pythonImportsCheck = [ "inverse_covariance" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Gaussian graphical models using the scikit-learn API";
    homepage = "https://github.com/skggm/skggm";
    changelog = "https://github.com/skggm/skggm/commits/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
