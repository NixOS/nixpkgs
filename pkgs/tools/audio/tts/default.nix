{ lib
, python3
, fetchFromGitHub
, fetchpatch
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

python3.pkgs.buildPythonApplication rec {
  pname = "tts";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "TTS";
    rev = "v${version}";
    sha256 = "sha256-ZcQUgr+1XTmXoyf2WNsP8Hept42JTFmKXdo0kcU6QWU=";
  };

  postPatch = ''
    sed -i requirements.txt \
      -e 's!librosa==[^"]*!librosa!' \
      -e 's!mecab-python3==[^"]*!mecab-python3!' \
      -e 's!numba==[^"]*!numba!' \
      -e 's!numpy==[^"]*!numpy!' \
      -e 's!umap-learn==[^"]*!umap-learn!'
  '';

  nativeBuildInputs = with python3.pkgs; [
    cython
  ];

  propagatedBuildInputs = with python3.pkgs; [
    anyascii
    coqpit
    flask
    fsspec
    gruut
    gdown
    inflect
    jieba
    librosa
    matplotlib
    mecab-python3
    numba
    pandas
    pypinyin
    pysbd
    pytorch
    pyworld
    scipy
    soundfile
    tensorboardx
    tensorflow
    tqdm
    umap-learn
    unidic-lite
  ];

  postInstall = ''
    cp -r TTS/server/templates/ $out/${python3.sitePackages}/TTS/server
    # cython modules are not installed for some reasons
    (
      cd TTS/tts/utils/monotonic_align
      ${python3.interpreter} setup.py install --prefix=$out
    )
  '';

  checkInputs = with python3.pkgs; [
    pytest-sugar
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: fft: ATen not compiled with MKL support
    "test_torch_stft"
    "test_stft_loss"
    "test_multiscale_stft_loss"
    # Requires network acccess to download models
    "test_synthesize"
  ];

  preCheck = ''
    # use the installed TTS in $PYTHONPATH instead of the one from source to also have cython modules.
    mv TTS{,.old}
    export PATH=$out/bin:$PATH

    # numba tries to write to HOME directory
    export HOME=$TMPDIR

    for file in $(grep -rl 'python TTS/bin' tests); do
      substituteInPlace "$file" \
        --replace "python TTS/bin" "${python3.interpreter} $out/lib/${python3.libPrefix}/site-packages/TTS/bin"
    done
  '';

  disabledTestPaths = [
    # requires tensorflow
    "tests/vocoder_tests/test_vocoder_tf_pqmf.py"
    "tests/vocoder_tests/test_vocoder_tf_melgan_generator.py"
    "tests/tts_tests/test_tacotron2_tf_model.py"
    # RuntimeError: fft: ATen not compiled with MKL support
    "tests/tts_tests/test_vits_train.py"
    "tests/vocoder_tests/test_fullband_melgan_train.py"
    "tests/vocoder_tests/test_hifigan_train.py"
    "tests/vocoder_tests/test_melgan_train.py"
    "tests/vocoder_tests/test_multiband_melgan_train.py"
    "tests/vocoder_tests/test_parallel_wavegan_train.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/coqui-ai/TTS";
    changelog = "https://github.com/coqui-ai/TTS/releases/tag/v${version}";
    description = "Deep learning toolkit for Text-to-Speech, battle-tested in research and production";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa mic92 ];
  };
}
