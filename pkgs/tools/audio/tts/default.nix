{ lib
, python3
, fetchFromGitHub
, espeak-ng
, tts
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      torch = super.torch-bin;
      torchvision = super.torchvision-bin;
      tensorflow = super.tensorflow-bin;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "tts";
  version = "0.20.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "TTS";
    rev = "refs/tags/v${version}";
    hash = "sha256-1nlSf15IEX1qKfDtR6+jQqskjxIuzaIWatkj9Z1fh8Y=";
  };

  postPatch = let
    relaxedConstraints = [
      "bnunicodenormalizer"
      "cython"
      "gruut"
      "inflect"
      "librosa"
      "mecab-python3"
      "numba"
      "numpy"
      "unidic-lite"
      "trainer"
    ];
  in ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (package:
        ''-e 's/${package}\s*[<>=]+.+/${package}/g' \''
      ) relaxedConstraints)}
    requirements.txt

    sed -r -i \
      ${lib.concatStringsSep "\n" (map (package:
        ''-e 's/${package}\s*[<>=]+[^"]+/${package}/g' \''
      ) relaxedConstraints)}
    pyproject.toml
    # only used for notebooks and visualization
    sed -r -i -e '/umap-learn/d' requirements.txt
  '';

  nativeBuildInputs = with python.pkgs; [
    cython
    numpy
    packaging
    setuptools
  ];

  propagatedBuildInputs = with python.pkgs; [
    anyascii
    bangla
    bnnumerizer
    bnunicodenormalizer
    coqpit
    einops
    encodec
    flask
    fsspec
    g2pkk
    gdown
    gruut
    inflect
    jamo
    jieba
    k-diffusion
    librosa
    matplotlib
    mecab-python3
    nltk
    numba
    packaging
    pandas
    pypinyin
    pysbd
    scipy
    soundfile
    tensorflow
    torch-bin
    torchaudio-bin
    tqdm
    trainer
    transformers
    unidic-lite
    webrtcvad
  ];

  postInstall = ''
    cp -r TTS/server/templates/ $out/${python.sitePackages}/TTS/server
    # cython modules are not installed for some reasons
    (
      cd TTS/tts/utils/monotonic_align
      ${python.pythonOnBuildForHost.interpreter} setup.py install --prefix=$out
    )
  '';

  # tests get stuck when run in nixpkgs-review, tested in passthru
  doCheck = false;
  passthru.tests.pytest = tts.overridePythonAttrs (_: { doCheck = true; });

  nativeCheckInputs = with python.pkgs; [
    espeak-ng
    pytestCheckHook
  ];

  preCheck = ''
    # use the installed TTS in $PYTHONPATH instead of the one from source to also have cython modules.
    mv TTS{,.old}
    export PATH=$out/bin:$PATH

    # numba tries to write to HOME directory
    export HOME=$TMPDIR

    for file in $(grep -rl 'python TTS/bin' tests); do
      substituteInPlace "$file" \
        --replace "python TTS/bin" "${python.interpreter} $out/${python.sitePackages}/TTS/bin"
    done
  '';

  disabledTests = [
    # Requires network acccess to download models
    "test_korean_text_to_phonemes"
    "test_models_offset_0_step_3"
    "test_models_offset_1_step_3"
    "test_models_offset_2_step_3"
    "test_run_all_models"
    "test_synthesize"
    "test_voice_cloning"
    "test_voice_conversion"
    "test_multi_speaker_multi_lingual_model"
    "test_single_speaker_model"
    # Mismatch between phonemes
    "test_text_to_ids_phonemes_with_eos_bos_and_blank"
    # Takes too long
    "test_parametrized_wavernn_dataset"
  ];

  disabledTestPaths = [
    # phonemes mismatch between espeak-ng and gruuts phonemizer
    "tests/text_tests/test_phonemizer.py"
    # no training, it takes too long
    "tests/aux_tests/test_speaker_encoder_train.py"
    "tests/tts_tests/test_align_tts_train.py"
    "tests/tts_tests/test_fast_pitch_speaker_emb_train.py"
    "tests/tts_tests/test_fast_pitch_train.py"
    "tests/tts_tests/test_fastspeech_2_speaker_emb_train.py"
    "tests/tts_tests/test_fastspeech_2_train.py"
    "tests/tts_tests/test_glow_tts_d-vectors_train.py"
    "tests/tts_tests/test_glow_tts_speaker_emb_train.py"
    "tests/tts_tests/test_glow_tts_train.py"
    "tests/tts_tests/test_neuralhmm_tts_train.py"
    "tests/tts_tests/test_overflow_train.py"
    "tests/tts_tests/test_speedy_speech_train.py"
    "tests/tts_tests/test_tacotron2_d-vectors_train.py"
    "tests/tts_tests/test_tacotron2_speaker_emb_train.py"
    "tests/tts_tests/test_tacotron2_train.py"
    "tests/tts_tests/test_tacotron_train.py"
    "tests/tts_tests/test_vits_d-vectors_train.py"
    "tests/tts_tests/test_vits_multilingual_speaker_emb_train.py"
    "tests/tts_tests/test_vits_multilingual_train-d_vectors.py"
    "tests/tts_tests/test_vits_speaker_emb_train.py"
    "tests/tts_tests/test_vits_train.py"
    "tests/vocoder_tests/test_wavegrad_train.py"
    "tests/vocoder_tests/test_parallel_wavegan_train.py"
    "tests/vocoder_tests/test_fullband_melgan_train.py"
    "tests/vocoder_tests/test_hifigan_train.py"
    "tests/vocoder_tests/test_multiband_melgan_train.py"
    "tests/vocoder_tests/test_melgan_train.py"
    "tests/vocoder_tests/test_wavernn_train.py"
    # only a feed forward test, but still takes too long
    "tests/tts_tests/test_overflow.py"
  ];

  passthru = {
    inherit python;
  };

  meta = with lib; {
    homepage = "https://github.com/coqui-ai/TTS";
    changelog = "https://github.com/coqui-ai/TTS/releases/tag/v${version}";
    description = "Deep learning toolkit for Text-to-Speech, battle-tested in research and production";
    license = licenses.mpl20;
    maintainers = teams.tts.members;
    broken = true; # added 2024-04-08
  };
}
