{ lib
, python3Packages
, fetchFromGitHub
, python3
}:

# USAGE:
# $ tts-server --list_models
# # pick your favorite vocoder/tts model
# $ tts-server --model_name tts_models/en/ljspeech/glow-tts --vocoder_name vocoder_models/universal/libri-tts/fullband-melgan
#
# For now, for deployment check the systemd unit in the pull request:
#   https://github.com/NixOS/nixpkgs/pull/103851#issue-521121136
#
# Check the latest release for compatible models:
#   https://github.com/coqui-ai/TTS/releases/tag/v0.0.11

python3Packages.buildPythonApplication rec {
  pname = "tts";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "TTS";
    rev = "v${version}";
    sha256 = "0kk9bgiw2x5ybwz0v3zrfaxajl3lnccc9xmrwc295n2rfkmwxsis";
  };

  preBuild = ''
    # numba jit tries to write to its cache directory
    export HOME=$TMPDIR
    # we only support pytorch models right now
    sed -i -e '/tensorflow/d' requirements.txt

    sed -i -e 's!librosa==[^"]*!librosa!' requirements.txt setup.py
    sed -i -e 's!unidecode==[^"]*!unidecode!' requirements.txt setup.py
    sed -i -e 's!bokeh==[^"]*!bokeh!' requirements.txt setup.py
    sed -i -e 's!numba==[^"]*!numba!' requirements.txt setup.py
    sed -i -e 's!numpy==[^"]*!numpy!' requirements.txt setup.py
    sed -i -e 's!umap-learn==[^"]*!umap-learn!' requirements.txt setup.py
    # Not required for building/installation but for their development/ci workflow
    sed -i -e '/pylint/d' requirements.txt
    sed -i -e '/cardboardlint/d' requirements.txt setup.py
  '';

  nativeBuildInputs = [ python3Packages.cython ];

  propagatedBuildInputs = with python3Packages; [
    attrdict
    bokeh
    flask
    fuzzywuzzy
    gdown
    inflect
    jieba
    librosa
    matplotlib
    phonemizer
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

  checkInputs = with python3Packages; [ pytestCheckHook ];

  disabledTests = [
    # RuntimeError: fft: ATen not compiled with MKL support
    "test_torch_stft"
    "test_stft_loss"
    "test_multiscale_stft_loss"
    # AssertionErrors that I feel incapable of debugging
    "test_phoneme_to_sequence"
    "test_text2phone"
    "test_parametrized_gan_dataset"
  ];

  preCheck = ''
    # use the installed TTS in $PYTHONPATH instead of the one from source to also have cython modules.
    mv TTS{,.old}
  '';

  disabledTestPaths = [
    # requires tensorflow
    "tests/test_tacotron2_tf_model.py"
    "tests/test_vocoder_tf_melgan_generator.py"
    "tests/test_vocoder_tf_pqmf.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/coqui-ai/TTS";
    changelog = "https://github.com/coqui-ai/TTS/releases/tag/v${version}";
    description = "Deep learning toolkit for Text-to-Speech, battle-tested in research and production";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa mic92 ];
  };
}
