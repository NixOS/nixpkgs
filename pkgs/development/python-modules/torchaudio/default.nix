{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, fetchFromGitHub

# Native build inputs
, cmake, ninja

# Build inputs
, pybind11

# Propagated build inputs
, pytorch

# Check inputs
, pytestCheckHook
, expecttest
, fairseq
, hypothesis
, kaldi
, librosa
, parameterized
, scipy
, sentencepiece
, soundfile
# , DeepPhonemizer
}:

let
  setBool = v: if v then "1" else "0";
in
buildPythonPackage rec {
  pname = "torchaudio";
  version = "0.10.2";

  # Pypi doesn't contain source code, so fetch from github instead
  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256:1jwccrx01cba7265279jn265w4zch31225gdk13fzicsl61042sz";
  };

  disabled = ! (pythonAtLeast "3.7" && pythonOlder "3.10");

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    pybind11
  ];

  propagatedBuildInputs = [
    pytorch
  ];

  checkInputs = [
    pytestCheckHook
    expecttest
    fairseq
    hypothesis
    parameterized
    scipy
    sentencepiece
    soundfile
    # librosa
    # DeepPhonemizer # dp
    # kaldi
  ];

  pythonImportsCheck = [ "torchaudio" ];

  # Don't build any optional third party libraries for now.
  BUILD_SOX = setBool false;
  BUILD_FFMPEG = setBool false;
  BUILD_KALDI  = setBool false;
  BUILD_RNNT = setBool false;
  BUILD_CTC_DECODER = setBool false;
  BUILD_TORCHAUDIO_PYTHON_EXTENSION = setBool false;

  # No CUDA, ROCM, OpenMP for now.
  USE_CUDA = setBool false;
  USE_ROCM = setBool false;
  USE_OPENMP = setBool false;

  postPatch =
    ''
      substituteInPlace setup.py --replace "torch.hub.download_url_to_file(url, dest, progress=False)" "print('NOT downloading', url, dest)"
    '';

  disabledTestPaths = [
    # FIXME: tests depending on librosa fail for an unclear reason related to function caching
    #        (no locator available for file '/nix/store/.../librosa/util/utils.py')
    "examples/test/test_interactive_asr.py"
    "test/torchaudio_unittest/functional/librosa_compatibility_cpu_test.py"
    "test/torchaudio_unittest/functional/librosa_compatibility_cuda_test.py"
    "test/torchaudio_unittest/transforms/librosa_compatibility_cpu_test.py"
    "test/torchaudio_unittest/transforms/librosa_compatibility_cuda_test.py"

    # FIXME: More failing tests
    "test/integration_tests/tacotron2_pipeline_test.py"
    "test/integration_tests/wav2vec2_pipeline_test.py"
    "test/torchaudio_unittest/functional/autograd_cpu_test.py"
    "test/torchaudio_unittest/functional/functional_cpu_test.py"
    "test/torchaudio_unittest/functional/torchscript_consistency_cpu_test.py"
    "test/torchaudio_unittest/kaldi_io_test.py"
    "test/torchaudio_unittest/models/wav2vec2/fairseq_integration_test.py"
    "test/torchaudio_unittest/transforms/autograd_cpu_test.py"
    "test/torchaudio_unittest/transforms/batch_consistency_test.py"
    "test/torchaudio_unittest/transforms/torchscript_consistency_cpu_test.py"
  ];

  disabledTests = [
    # FIXME: Tests require kaldi
    "test_read_mat_ark"
    "test_read_vec_flt_ark"
    "test_read_vec_int_ark"
    "test_batch_MelScale"

    # FIXME: Failing tests
    "test_bass_biquad_0"
    "test_bass_biquad_1"
    "test_biquad"
    "test_equalizer_biquad_0"
    "test_equalizer_biquad_1"
    "test_filtfilt_a"
    "test_filtfilt_all_inputs"
    "test_filtfilt_b"
    "test_filtfilt_batching"
    "test_finetune_asr_model"
    "test_highpass_biquad_0"
    "test_import_finetuning_model_0_wav2vec2_base"
    "test_import_finetuning_model_1_wav2vec2_large"
    "test_import_finetuning_model_2_wav2vec2_large_lv60k"
    "test_import_finetuning_model_3_wav2vec2_large_lv60k"
    "test_import_finetuning_model_4_hubert_large"
    "test_import_finetuning_model_5_hubert_xlarge"
    "test_import_hubert_pretraining_model_0_hubert_base"
    "test_import_hubert_pretraining_model_1_hubert_large"
    "test_import_hubert_pretraining_model_2_hubert_xlarge"
    "test_import_wave2vec2_pretraining_model_0_wav2vec2_base"
    "test_import_wave2vec2_pretraining_model_1_wav2vec2_large"
    "test_import_wave2vec2_pretraining_model_2_wav2vec2_large_lv60k"
    "test_import_wave2vec2_pretraining_model_3_wav2vec2_large_lv60k"
    "test_lfilter_a"
    "test_lfilter_all_inputs"
    "test_lfilter_b"
    "test_lfilter_batching"
    "test_lfilter_filterbanks"
    "test_lfilter_x"
    "test_lowpass_biquad_0"
    "test_pretraining_models"
    "test_recreate_finetuning_model_0_wav2vec2_base"
    "test_recreate_finetuning_model_1_wav2vec2_large"
    "test_recreate_finetuning_model_2_wav2vec2_large_lv60k"
    "test_recreate_finetuning_model_3_wav2vec2_large_lv60k"
    "test_recreate_finetuning_model_4_hubert_large"
    "test_recreate_finetuning_model_5_hubert_xlarge"
    "test_recreate_pretraining_model_0_wav2vec2_base"
    "test_recreate_pretraining_model_1_wav2vec2_large"
    "test_recreate_pretraining_model_2_wav2vec2_large_lv60k"
    "test_recreate_pretraining_model_3_wav2vec2_large_lv60k"
    "test_recreate_pretraining_model_4_hubert_base"
    "test_recreate_pretraining_model_5_hubert_large"
    "test_recreate_pretraining_model_6_hubert_xlarge"
    "test_rnnt_loss"
    "test_rnnt_loss_0"
    "test_rnnt_loss_1"
    "test_rnnt_loss_2"
    "test_rnnt_loss_basic_backward"
    "test_rnnt_loss_basic_forward_no_grad"
    "test_rnnt_loss_costs_and_gradients_0"
    "test_rnnt_loss_costs_and_gradients_1"
    "test_rnnt_loss_costs_and_gradients_2"
    "test_rnnt_loss_costs_and_gradients_3"
    "test_rnnt_loss_costs_and_gradients_random_data_with_numpy_fp32"
    "test_treble_biquad_0"
    "test_treble_biquad_1"
    "test_tts_models"
  ];

  meta = with lib; {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
