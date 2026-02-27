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
  omegaconf,
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
buildPythonPackage (finalAttrs: {
  pname = "whisperx";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-bain";
    repo = "whisperX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2HjQtb8k3px0kqXowKtCXkiG2GuKLCuCtDOPYYa/tbc=";
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
    "torch"
    "torchaudio"
  ];
  dependencies = [
    ctranslate
    faster-whisper
    huggingface-hub
    nltk
    numpy
    omegaconf
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

  pythonImportsCheck = [ "whisperx" ];

  meta = {
    mainProgram = "whisperx";
    description = "Automatic Speech Recognition with Word-level Timestamps (& Diarization)";
    homepage = "https://github.com/m-bain/whisperX";
    changelog = "https://github.com/m-bain/whisperX/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bengsparks ];
  };
})
