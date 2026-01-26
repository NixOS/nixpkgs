{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  av,
  ctranslate2,
  faster-whisper,
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
  version = "3.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-bain";
    repo = "whisperX";
    tag = "v${version}";
    hash = "sha256-wmCGHRx1JaOs5+7fp2jeh8PIR5dlmOl8hKrIw2550Bk=";
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
    "av"
    "numpy"
    "pandas"
    "pyannote-audio"
    "torch"
    "torchaudio"
  ];
  dependencies = [
    av
    ctranslate
    faster-whisper
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

  # Import check fails due on `aarch64-linux` ONLY in the sandbox due to onnxruntime
  # not finding its default logger, which then promptly segfaults.
  # Simply run the import check on every other platform instead.
  pythonImportsCheck = lib.optionals (
    !(stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux)
  ) [ "whisperx" ];

  # No tests in repository
  doCheck = false;

  meta = {
    mainProgram = "whisperx";
    description = "Automatic Speech Recognition with Word-level Timestamps (& Diarization)";
    homepage = "https://github.com/m-bain/whisperX";
    changelog = "https://github.com/m-bain/whisperX/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
