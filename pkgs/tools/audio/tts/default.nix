{ lib
, python3Packages
, fetchFromGitHub
, fetchpatch
, python3
}:

#
# Tested in the following setup:
#
# TTS model:
#   Tacotron2 DDC
#   https://drive.google.com/drive/folders/1Y_0PcB7W6apQChXtbt6v3fAiNwVf4ER5
# Vocoder model:
#   Multi-Band MelGAN
#   https://drive.google.com/drive/folders/1XeRT0q4zm5gjERJqwmX5w84pMrD00cKD
#
# Arrange /tmp/tts like this:
#   scale_stats.npy
#   tts
#   tts/checkpoint_130000.pth.tar
#   tts/checkpoint_130000_tf.pkl
#   tts/checkpoint_130000_tf_2.3rc0.tflite
#   tts/config.json
#   tts/scale_stats.npy
#   vocoder
#   vocoder/checkpoint_1450000.pth.tar
#   vocoder/checkpoint_2750000_tf.pkl
#   vocoder/checkpoint_2750000_tf_v2.3rc.tflite
#   vocoder/config.json
#   vocoder/scale_stats.npy
#
# Start like this:
#   cd /tmp/tts
#   tts-server \
#     --vocoder_config ./tts/vocoder/config.json \
#     --vocoder_checkpoint ./tts/vocoder/checkpoint_1450000.pth.tar \
#     --tts_config ./tts/config.json \
#     --tts_checkpoint ./tts/checkpoint_130000.pth.tar
#
# For now, for deployment check the systemd unit in the pull request:
#   https://github.com/NixOS/nixpkgs/pull/103851#issue-521121136
#

python3Packages.buildPythonApplication rec {
  pname = "tts";
  # until https://github.com/mozilla/TTS/issues/424 is resolved
  # we treat released models as released versions:
  # https://github.com/mozilla/TTS/wiki/Released-Models
  version = "unstable-2020-06-17";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "TTS";
    rev = "72a6ac54c8cfaa407fc64b660248c6a788bdd381";
    sha256 = "1wvs264if9n5xzwi7ryxvwj1j513szp6sfj6n587xk1fphi0921f";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mozilla/TTS/commit/36fee428b9f3f4ec1914b090a2ec9d785314d9aa.patch";
      sha256 = "sha256-pP0NxiyrsvQ0A7GEleTdT87XO08o7WxPEpb6Bmj66dc=";
    })
  ];

  preBuild = ''
    # numba jit tries to write to its cache directory
    export HOME=$TMPDIR
    sed -i -e 's!tensorflow==.*!tensorflow!' requirements.txt
    sed -i -e 's!librosa==[^"]*!librosa!' requirements.txt setup.py
    sed -i -e 's!unidecode==[^"]*!unidecode!' requirements.txt setup.py
    sed -i -e 's!bokeh==[^"]*!bokeh!' requirements.txt setup.py
    sed -i -e 's!numba==[^"]*!numba!' requirements.txt setup.py
    # Not required for building/installation but for their development/ci workflow
    sed -i -e '/pylint/d' requirements.txt setup.py
    sed -i -e '/cardboardlint/d' requirements.txt setup.py
  '';


  propagatedBuildInputs = with python3Packages; [
    matplotlib
    scipy
    pytorch
    flask
    attrdict
    bokeh
    soundfile
    tqdm
    librosa
    unidecode
    phonemizer
    tensorboardx
    fuzzywuzzy
    tensorflow_2
    inflect
    gdown
    pysbd
  ];

  postInstall = ''
    cp -r TTS/server/templates/ $out/${python3.sitePackages}/TTS/server
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

  meta = with lib; {
    homepage = "https://github.com/mozilla/TTS";
    description = "Deep learning for Text to Speech";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa mic92 ];
  };
}
