{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, phonemizer
, tensorboardx
, matplotlib
, scipy
, pytorch
, flask
, attrdict
, bokeh
, soundfile
, tqdm
, librosa
, unidecode
, parallel-wavegan
}:

buildPythonPackage rec {
  pname = "tts";
  # until https://github.com/mozilla/TTS/issues/424 is resolved
  # we treat released models as released versions:
  # https://github.com/mozilla/TTS/wiki/Released-Models
  version = "unstable-2020-04-23";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "TTS";
    rev = "53b24625a7b898447b0cda2929503b96752d9eae";
    sha256 = "1mcv3lfpr6dfy57af1ysf6dv6q8l7xq3b6iim10z9rn2zqsklbxf";
  };

  patches = [
    ./loosen-deps.patch
    # add tts-server executable
    # https://github.com/mozilla/TTS/pull/425
    (fetchpatch {
      url = "https://github.com/mozilla/TTS/commit/edf257a91363c4c58b6e1c9e1a9e7f3b0b37dd17.patch";
      sha256 = "087hj13f9kf31i2nvwhkdx37y3qwgdxayzfpv0am5b3f5alsr6xb";
    })
    # allow to load vocoder from PYTHONPATH
    # https://github.com/mozilla/TTS/pull/426
    (fetchpatch {
      url = "https://github.com/mozilla/TTS/commit/edf257a91363c4c58b6e1c9e1a9e7f3b0b37dd17.patch";
      sha256 = "087hj13f9kf31i2nvwhkdx37y3qwgdxayzfpv0am5b3f5alsr6xb";
    })
    ./0001-fix-pwgan-vocoder-with-pytorch-1.5.patch
  ];

  propagatedBuildInputs = [
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
    parallel-wavegan
  ];

  preBuild = ''
    # numba jit tries to write to its cache directory
    export HOME=$TMPDIR
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mozilla/TTS";
    description = "Deep learning for Text to Speech";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa mic92 ];
  };
}
