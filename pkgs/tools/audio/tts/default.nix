{ lib
, python3
, fetchFromGitHub
, espeak-ng
}:

# USAGE:
# $ tts-server --list_models
# # pick your favorite vocoder/tts model
# $ tts-server --model_name tts_models/en/ljspeech/glow-tts --vocoder_name vocoder_models/universal/libri-tts/fullband-melgan
#
# If you upgrade from an old version you may have to delete old models from ~/.local/share/tts
#
# For now, for deployment check the systemd unit in the pull request:
#   https://github.com/NixOS/nixpkgs/pull/103851#issue-521121136

let
  python = python3.override {
    packageOverrides = self: super: {
      # API breakage with 0.9.0
      # TypeError: mel() takes 0 positional arguments but 2 positional arguments (and 3 keyword-only arguments) were given
      librosa = super.librosa.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.1";
        src = super.fetchPypi {
          pname = "librosa";
          inherit version;
          sha256 = "c53d05e768ae4a3e553ae21c2e5015293e5efbfd5c12d497f1104cb519cca6b3";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "tts";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "TTS";
    rev = "v${version}";
    sha256 = "sha256-ch+711soRfZj1egyaF0+6NrUJtf7JqfZuxQ4eDf1zas=";
  };

  postPatch = let
    relaxedConstraints = [
      "cython"
      "gruut"
      "librosa"
      "mecab-python3"
      "numba"
      "numpy"
      "umap-learn"
      "unidic-lite"
      "pyworld"
    ];
  in ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (package:
        ''-e 's/${package}.*[<>=]+.*/${package}/g' \''
      ) relaxedConstraints)}
    requirements.txt
    sed -i '/tensorboardX/d' requirements.txt
  '';

  nativeBuildInputs = with python.pkgs; [
    cython
  ];

  propagatedBuildInputs = with python.pkgs; [
    anyascii
    coqpit
    coqui-trainer
    flask
    fsspec
    gdown
    gruut
    inflect
    jieba
    librosa
    matplotlib
    mecab-python3
    numba
    pandas
    pypinyin
    pysbd
    pyworld
    scipy
    soundfile
    tensorflow
    torch-bin
    torchaudio-bin
    tqdm
    umap-learn
    unidic-lite
    webrtcvad
  ];

  postInstall = ''
    cp -r TTS/server/templates/ $out/${python.sitePackages}/TTS/server
    # cython modules are not installed for some reasons
    (
      cd TTS/tts/utils/monotonic_align
      ${python.interpreter} setup.py install --prefix=$out
    )
  '';

  checkInputs = with python.pkgs; [
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
        --replace "python TTS/bin" "${python.interpreter} $out/lib/${python.libPrefix}/site-packages/TTS/bin"
    done
  '';

  disabledTests = [
    # Requires network acccess to download models
    "test_synthesize"
    "test_run_all_models"
    # Mismatch between phonemes
    "test_text_to_ids_phonemes_with_eos_bos_and_blank"
    # Takes too long
    "test_parametrized_wavernn_dataset"

    # requires network
    "test_voice_conversion"
  ];

  disabledTestPaths = [
    # Requires network acccess to download models
    "tests/aux_tests/test_remove_silence_vad_script.py"
    # phonemes mismatch between espeak-ng and gruuts phonemizer
    "tests/text_tests/test_phonemizer.py"
    # no training, it takes too long
    "tests/aux_tests/test_speaker_encoder_train.py"
    "tests/tts_tests/test_align_tts_train.py"
    "tests/tts_tests/test_fast_pitch_speaker_emb_train.py"
    "tests/tts_tests/test_fast_pitch_train.py"
    "tests/tts_tests/test_glow_tts_d-vectors_train.py"
    "tests/tts_tests/test_glow_tts_speaker_emb_train.py"
    "tests/tts_tests/test_glow_tts_train.py"
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
  ];

  meta = with lib; {
    homepage = "https://github.com/coqui-ai/TTS";
    changelog = "https://github.com/coqui-ai/TTS/releases/tag/v${version}";
    description = "Deep learning toolkit for Text-to-Speech, battle-tested in research and production";
    license = licenses.mpl20;
    maintainers = teams.tts.members;
  };
}
