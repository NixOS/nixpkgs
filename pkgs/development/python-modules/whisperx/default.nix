{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ctranslate2,
  faster-whisper,
  huggingface-hub,
  nltk,
  numpy,
  pandas,
  pyannote-audio,
  torch,
  torchaudio,
  transformers,
  triton,

  # native packages
  ffmpeg,
  ctranslate2-cpp, # alias for `pkgs.ctranslate2`, required due to colliding with the `ctranslate2` Python module.

  # enable GPU support
  cudaSupport ? torch.cudaSupport,
}:

let
  ctranslate = ctranslate2.override {
    ctranslate2-cpp = ctranslate2-cpp.override {
      withCUDA = cudaSupport;
      withCuDNN = cudaSupport;
    };
  };
in
buildPythonPackage rec {
  pname = "whisperx";
  version = "3.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-bain";
    repo = "whisperX";
    tag = "v${version}";
    hash = "sha256-ZHPGQP5HIuFafHGS6ykiSNtHY6QHh0o8DUE2lV41lUI=";
  };

  # As `makeWrapperArgs` does not apply to the module, and whisperx depends on `ffmpeg`,
  # we replace the `"ffmpeg"` string in `subprocess.run` with the full path to the binary.
  # This works for both the program and the module.
  # Every update, the codebase should be checked for further instances of `ffmpeg` calls.
  postPatch = ''
    substituteInPlace whisperx/audio.py --replace-fail \
      '"ffmpeg"' '"${lib.getExe ffmpeg}"'
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "numpy"
    "pandas"
    "pyannote-audio"
    "torch"
    "torchaudio"
  ];
  dependencies = [
    ctranslate
    faster-whisper
    huggingface-hub
    nltk
    numpy
    pandas
    pyannote-audio
    torch
    torchaudio
    transformers
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    triton
  ];

  # No tests in repository
  doCheck = false;

  meta = {
    mainProgram = "whisperx";
    description = "Automatic Speech Recognition with Word-level Timestamps (& Diarization)";
    homepage = "https://github.com/m-bain/whisperX";
    changelog = "https://github.com/m-bain/whisperX/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bengsparks ];

    # nixpkgs has `pyannote-audio` >= 4.0.0, but `whisperx`'s `pyproject.toml` specifies <4.0.0.
    #
    # See https://github.com/m-bain/whisperX/issues/1240 for a serious discussion,
    # and a potential upgrade in https://github.com/m-bain/whisperX/pull/1243.
    # Alternatively read https://github.com/m-bain/whisperX/issues/1336 if you prefer a more humorous perspective.
    #
    # Failure was first documented in nixpkgs under https://github.com/NixOS/nixpkgs/issues/460172.
    broken = true;
  };
}
