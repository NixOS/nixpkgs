{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,

  # tests
  cython,
  numpy,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  scikit-image,
  scikit-learn,
  torchtnt-nightly,
  torchvision,
}:
let
  pname = "torcheval";
  version = "0.0.7";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "torcheval";
    # Upstream has not created a tag for this version
    # https://github.com/pytorch/torcheval/issues/215
    rev = "f1bc22fc67ec2c77ee519aa4af8079f4fdaa41bb";
    hash = "sha256-aVr4qKKE+dpBcJEi1qZJBljFLUl8d7D306Dy8uOojJE=";
  };

  # Patches are only applied to usages of numpy within tests,
  # which are only used for testing purposes (see dev-requirements.txt)
  postPatch =
    # numpy's `np.NAN` was changed to `np.nan` when numpy 2 was released
    ''
      substituteInPlace tests/metrics/classification/test_accuracy.py tests/metrics/functional/classification/test_accuracy.py \
        --replace-fail "np.NAN" "np.nan"
    ''

    # `unittest.TestCase.assertEquals` does not exist;
    # the correct symbol is `unittest.TestCase.assertEqual`
    + ''
      substituteInPlace tests/metrics/test_synclib.py \
        --replace-fail "tc.assertEquals" "tc.assertEqual"
    '';

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "torcheval" ];

  nativeCheckInputs = [
    cython
    numpy
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    scikit-image
    scikit-learn
    torchtnt-nightly
    torchvision
  ];

  pytestFlagsArray = [
    "-v"
    "tests/"

    # -- tests/metrics/audio/test_fad.py --
    # Touch filesystem and require network access.
    # torchaudio.utils.download_asset("models/vggish.pt") -> PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
    "--deselect=tests/metrics/audio/test_fad.py::TestFAD::test_vggish_fad"
    "--deselect=tests/metrics/audio/test_fad.py::TestFAD::test_vggish_fad_merge"

    # -- tests/metrics/image/test_fid.py --
    # Touch filesystem and require network access.
    # models.inception_v3(weights=weights) -> PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
    "--deselect=tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_invalid_input"
    "--deselect=tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_random_data_custom_model"
    "--deselect=tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_random_data_default_model"
    "--deselect=tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_with_dissimilar_inputs"
    "--deselect=tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_with_similar_inputs"

    # -- tests/metrics/functional/text/test_perplexity.py --
    # AssertionError: Scalars are not close!
    # Expected 3.537154912949 but got 3.53715443611145
    "--deselect=tests/metrics/functional/text/test_perplexity.py::Perplexity::test_perplexity_with_ignore_index"

    # -- tests/metrics/image/test_psnr.py --
    # AssertionError: Scalars are not close!
    # Expected 7.781850814819336 but got 7.781772613525391
    "--deselect=tests/metrics/image/test_psnr.py::TestPeakSignalNoiseRatio::test_psnr_with_random_data"

    # -- tests/metrics/regression/test_mean_squared_error.py --
    # AssertionError: Scalars are not close!
    # Expected -640.4547729492188 but got -640.4707641601562
    "--deselect=tests/metrics/regression/test_mean_squared_error.py::TestMeanSquaredError::test_mean_squared_error_class_update_input_shape_different"
  ];

  meta = {
    description = "Rich collection of performant PyTorch model metrics and tools for PyTorch model evaluations";
    homepage = "https://pytorch.org/torcheval";
    changelog = "https://github.com/pytorch/torcheval/releases/tag/${version}";

    platforms = lib.platforms.linux;
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ bengsparks ];
  };
}
