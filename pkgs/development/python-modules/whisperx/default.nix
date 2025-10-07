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
  nltk,
  pandas,
  pyannote-audio,
  torch,
  torchaudio,
  transformers,

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
  version = "3.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-bain";
    repo = "whisperX";
    tag = "v${version}";
    hash = "sha256-zx77Fx8KYTWCFcC6Uy6pbe8LJtXP3b6lkwuOSEEYJfU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ctranslate
    faster-whisper
    nltk
    pandas
    pyannote-audio # Missing from pyproject.toml, but used in `whisperx/vad.py`
    torch
    torchaudio
    transformers
  ];

  # As `makeWrapperArgs` does not apply to the module, and whisperx depends on `ffmpeg`,
  # we replace the `"ffmpeg"` string in `subprocess.run` with the full path to the binary.
  # This works for both the program and the module.
  # Every update, the codebase should be checked for further instances of `ffmpeg` calls.
  postPatch = ''
    substituteInPlace whisperx/audio.py --replace-fail \
      '"ffmpeg"' '"${lib.getExe ffmpeg}"'
  '';

  pythonRelaxDeps = [
    # > Checking runtime dependencies for whisperx-3.3.2-py3-none-any.whl
    # >   - faster-whisper==1.1.0 not satisfied by version 1.1.1
    # This has been updated on main, so we expect this clause to be removed upon the next update.
    "faster-whisper"

    "ctranslate2"
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
