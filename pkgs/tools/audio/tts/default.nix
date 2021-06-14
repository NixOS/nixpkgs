{ lib
, python3Packages
, fetchFromGitHub
, python3
, fetchpatch
}:

# USAGE:
# $ tts-server --list_models
# # pick your favorite vocoder/tts model
# $ tts-server --model_name tts_models/en/ljspeech/glow-tts --vocoder_name vocoder_models/universal/libri-tts/fullband-melgan
#
# If you upgrade from an old version you may have to delete old models from ~/.local/share/tts
# Also note that your tts version might not support all available models so check:
#   https://github.com/coqui-ai/TTS/releases/tag/v0.0.14
#
# For now, for deployment check the systemd unit in the pull request:
#   https://github.com/NixOS/nixpkgs/pull/103851#issue-521121136

python3Packages.buildPythonApplication rec {
  pname = "tts";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "TTS";
    rev = "v${version}";
    sha256 = "0cl0ri90mx0y19fmqww73lp5nv6qkpc45rm4157i7p6q6llajdhp";
  };

  postPatch = ''
    sed -i -e 's!librosa==[^"]*!librosa!' requirements.txt
    sed -i -e 's!unidecode==[^"]*!unidecode!' requirements.txt
    sed -i -e 's!numba==[^"]*!numba!' requirements.txt
    sed -i -e 's!numpy==[^"]*!numpy!' requirements.txt
    sed -i -e 's!umap-learn==[^"]*!umap-learn!' requirements.txt
  '';

  nativeBuildInputs = with python3Packages; [
    cython
  ];

  propagatedBuildInputs = with python3Packages; [
    coqpit
    flask
    gdown
    inflect
    jieba
    librosa
    matplotlib
    numba
    pandas
    pypinyin
    pysbd
    pytorch
    scipy
    soundfile
    tensorboardx
    tqdm
    umap-learn
    unidecode
  ];

  postInstall = ''
    cp -r TTS/server/templates/ $out/${python3.sitePackages}/TTS/server
    # cython modules are not installed for some reasons
    (
      cd TTS/tts/layers/glow_tts/monotonic_align
      ${python3Packages.python.interpreter} setup.py install --prefix=$out
    )
  '';

  checkInputs = with python3Packages; [
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
    "tests/test_tacotron2_tf_model.py"
    "tests/vocoder_tests/test_vocoder_tf_pqmf.py"
    "tests/vocoder_tests/test_vocoder_tf_melgan_generator.py"
    # RuntimeError: fft: ATen not compiled with MKL support
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
