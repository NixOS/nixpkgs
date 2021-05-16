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
#   https://github.com/coqui-ai/TTS/releases/tag/v0.0.13
#
# For now, for deployment check the systemd unit in the pull request:
#   https://github.com/NixOS/nixpkgs/pull/103851#issue-521121136

python3Packages.buildPythonApplication rec {
  pname = "tts";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "TTS";
    rev = "v${version}";
    sha256 = "1sh7sjkh7ihbkqc7sl4hnzci0n7gv4s140dykpb1havaqyfhjn8l";
  };

  preBuild = ''
    sed -i -e 's!librosa==[^"]*!librosa!' requirements.txt
    sed -i -e 's!unidecode==[^"]*!unidecode!' requirements.txt
    sed -i -e 's!numpy==[^"]*!numpy!' requirements.txt
    sed -i -e 's!umap-learn==[^"]*!umap-learn!' requirements.txt
  '';

  nativeBuildInputs = with python3Packages; [
    cython
  ];

  propagatedBuildInputs = with python3Packages; [
    flask
    gdown
    inflect
    jieba
    librosa
    matplotlib
    pandas
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

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: fft: ATen not compiled with MKL support
    "test_torch_stft"
    "test_stft_loss"
    "test_multiscale_stft_loss"
    # assert tensor(1.1904e-07, dtype=torch.float64) <= 0
    "test_parametrized_gan_dataset"
    # RuntimeError: expected scalar type Double but found Float
    "test_speaker_embedding"
    # Requires network acccess to download models
    "test_synthesize"
  ];

  preCheck = ''
    # use the installed TTS in $PYTHONPATH instead of the one from source to also have cython modules.
    mv TTS{,.old}
    export PATH=$out/bin:$PATH

    # numba tries to write to HOME directory
    export HOME=$TMPDIR
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
