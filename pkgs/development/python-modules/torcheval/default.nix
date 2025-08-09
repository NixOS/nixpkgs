{
  lib,
  stdenv,
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

  pytestFlags = [
    "-v"
  ];

  enabledTestPaths = [
    "tests/"
  ];

  disabledTestPaths = [
    # -- tests/metrics/audio/test_fad.py --
    # Touch filesystem and require network access.
    # torchaudio.utils.download_asset("models/vggish.pt") -> PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
    "tests/metrics/audio/test_fad.py::TestFAD::test_vggish_fad"
    "tests/metrics/audio/test_fad.py::TestFAD::test_vggish_fad_merge"

    # -- tests/metrics/image/test_fid.py --
    # Touch filesystem and require network access.
    # models.inception_v3(weights=weights) -> PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
    "tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_invalid_input"
    "tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_random_data_custom_model"
    "tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_random_data_default_model"
    "tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_with_dissimilar_inputs"
    "tests/metrics/image/test_fid.py::TestFrechetInceptionDistance::test_fid_with_similar_inputs"

    # -- tests/metrics/functional/text/test_perplexity.py --
    # AssertionError: Scalars are not close!
    # Expected 3.537154912949 but got 3.53715443611145
    "tests/metrics/functional/text/test_perplexity.py::Perplexity::test_perplexity_with_ignore_index"

    # -- tests/metrics/image/test_psnr.py --
    # AssertionError: Scalars are not close!
    # Expected 7.781850814819336 but got 7.781772613525391
    "tests/metrics/image/test_psnr.py::TestPeakSignalNoiseRatio::test_psnr_with_random_data"

    # -- tests/metrics/regression/test_mean_squared_error.py --
    # AssertionError: Scalars are not close!
    # Expected -640.4547729492188 but got -640.4707641601562
    "tests/metrics/regression/test_mean_squared_error.py::TestMeanSquaredError::test_mean_squared_error_class_update_input_shape_different"

    # -- tests/metrics/window/test_mean_squared_error.py --
    # AssertionError: Scalars are not close!
    # Expected 0.0009198983898386359 but got 0.0009198188781738281
    "tests/metrics/window/test_mean_squared_error.py::TestMeanSquaredError::test_mean_squared_error_class_update_input_shape_different"
  ]

  # These tests error on darwin platforms.
  # NotImplementedError: The operator 'c10d::allgather_' is not currently implemented for the mps device
  #
  # Applying the suggested environment variable `PYTORCH_ENABLE_MPS_FALLBACK=1;` causes the tests to fail,
  # as using the CPU instead of the MPS causes the tensors to be on the wrong device:
  # RuntimeError: ProcessGroupGloo::allgather: invalid tensor type at index 0;
  # Expected TensorOptions(dtype=float, device=cpu, ...), got TensorOptions(dtype=float, device=mps:0, ...)
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    # -- tests/metrics/test_synclib.py --
    "tests/metrics/test_synclib.py::SynclibTest::test_complex_mixed_state_sync"
    "tests/metrics/test_synclib.py::SynclibTest::test_complex_mixed_state_sync"
    "tests/metrics/test_synclib.py::SynclibTest::test_empty_tensor_list_sync_state"
    "tests/metrics/test_synclib.py::SynclibTest::test_sync_dtype_and_shape"
    "tests/metrics/test_synclib.py::SynclibTest::test_tensor_list_sync_states"
    "tests/metrics/test_synclib.py::SynclibTest::test_tensor_dict_sync_states"
    "tests/metrics/test_synclib.py::SynclibTest::test_tensor_sync_states"
    # -- tests/metrics/test_toolkit.py --
    "tests/metrics/test_toolkit.py::MetricToolkitTest::test_metric_sync"
    "tests/metrics/test_toolkit.py::MetricCollectionToolkitTest::test_metric_collection_sync"

    # Cannot access local process over IPv6 (nodename nor servname provided) even with __darwinAllowLocalNetworking
    # Will hang, or appear to hang, with an 5 minute (default) timeout per test
    "tests/metrics/aggregation/test_auc.py"
    "tests/metrics/aggregation/test_cat.py"
    "tests/metrics/aggregation/test_max.py"
    "tests/metrics/aggregation/test_mean.py"
    "tests/metrics/aggregation/test_min.py"
    "tests/metrics/aggregation/test_sum.py"
    "tests/metrics/aggregation/test_throughput.py"
    "tests/metrics/classification/test_accuracy.py"
    "tests/metrics/classification/test_auprc.py"
    "tests/metrics/classification/test_auroc.py"
    "tests/metrics/classification/test_binned_auprc.py"
    "tests/metrics/classification/test_binned_auroc.py"
    "tests/metrics/classification/test_binned_precision_recall_curve.py"
    "tests/metrics/classification/test_confusion_matrix.py"
    "tests/metrics/classification/test_f1_score.py"
    "tests/metrics/classification/test_normalized_entropy.py"
    "tests/metrics/classification/test_precision_recall_curve.py"
    "tests/metrics/classification/test_precision.py"
    "tests/metrics/classification/test_recall_at_fixed_precision.py"
    "tests/metrics/classification/test_recall.py"
    "tests/metrics/functional/classification/test_auroc.py"
    "tests/metrics/ranking/test_click_through_rate.py::TestClickThroughRate::test_ctr_with_valid_input"
    "tests/metrics/ranking/test_hit_rate.py::TestHitRate::test_hitrate_with_valid_input"
    "tests/metrics/ranking/test_reciprocal_rank.py::TestReciprocalRank::test_mrr_with_valid_input"
    "tests/metrics/ranking/test_retrieval_precision.py::TestRetrievalPrecision::test_retrieval_precision_multiple_updates_1_query"
    "tests/metrics/ranking/test_retrieval_precision.py::TestRetrievalPrecision::test_retrieval_precision_multiple_updates_n_queries_without_nan"
    "tests/metrics/ranking/test_weighted_calibration.py::TestWeightedCalibration::test_weighted_calibration_with_valid_input"
    "tests/metrics/regression/test_mean_squared_error.py"
    "tests/metrics/regression/test_r2_score.py"
    "tests/metrics/test_synclib.py::SynclibTest::test_gather_uneven_multidim"
    "tests/metrics/test_synclib.py::SynclibTest::test_gather_uneven"
    "tests/metrics/test_synclib.py::SynclibTest::test_numeric_sync_state"
    "tests/metrics/test_synclib.py::SynclibTest::test_sync_list_length"
    "tests/metrics/text/test_bleu.py::TestBleu::test_bleu_multiple_examples_per_update"
    "tests/metrics/text/test_bleu.py::TestBleu::test_bleu_multiple_updates"
    "tests/metrics/text/test_perplexity.py::TestPerplexity::test_perplexity_with_ignore_index"
    "tests/metrics/text/test_perplexity.py::TestPerplexity::test_perplexity"
    "tests/metrics/text/test_word_error_rate.py::TestWordErrorRate::test_word_error_rate_with_valid_input"
    "tests/metrics/text/test_word_information_lost.py::TestWordInformationLost::test_word_information_lost"
    "tests/metrics/text/test_word_information_preserved.py::TestWordInformationPreserved::test_word_information_preserved_with_valid_input"
    "tests/metrics/window/test_auroc.py"
    "tests/metrics/window/test_click_through_rate.py::TestClickThroughRate::test_ctr_with_valid_input"
    "tests/metrics/window/test_mean_squared_error.py"
    "tests/metrics/window/test_normalized_entropy.py::TestWindowedBinaryNormalizedEntropy::test_ne_with_valid_input"
    "tests/metrics/window/test_weighted_calibration.py::TestWindowedWeightedCalibration::test_weighted_calibration_with_valid_input"
  ];

  meta = {
    description = "Rich collection of performant PyTorch model metrics and tools for PyTorch model evaluations";
    homepage = "https://pytorch.org/torcheval";
    changelog = "https://github.com/pytorch/torcheval/releases/tag/${version}";

    platforms = lib.platforms.unix;
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
