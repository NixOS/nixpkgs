{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  ctranslate2,
  ctranslate2-cpp,
  faster-whisper,
  ffmpeg,
  nltk,
  pandas,
  pyannote-audio,
  torch,
  torchaudio,
  transformers,

  cudaSupport ? torch.cudaSupport,
  cudaPackages,
}:

let
  # inherit (cudaPackages) cudaFlags cudnn nccl;

  ctranslate = ctranslate2.override {
    ctranslate2-cpp = ctranslate2-cpp.override {
      withCUDA = cudaSupport ? false;
      withCuDNN = cudaSupport ? false;
    };
  };
in
buildPythonPackage rec {
  pname = "whisperx";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-bain";
    repo = "whisperX";
    tag = "v${version}";
    hash = "sha256-Wb9jKTs0rTdgjvcnKl1P8Uh6b5jzlkKgQBcJYA+7+W4=";
  };

  nativeBuildInputs = lib.optionals cudaSupport ( with cudaPackages; [

  ]);

  build-system = [ setuptools ];

  dependencies = [
    ctranslate
    faster-whisper
    nltk
    pandas
    pyannote-audio
    torch
    torchaudio
    transformers
  ];

  pythonRelaxDeps = [
    "ctranslate2"
    "faster-whisper"
  ];

  pythonImportsCheck = [ "whisperx" ];

  # No tests in repository
  doCheck = false;

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}" ];

  meta = {
    mainProgram = "whisperx";
    description = "Automatic Speech Recognition with Word-level Timestamps (& Diarization)";
    homepage = "https://github.com/m-bain/whisperX";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bengsparks ];

    platforms =
      if cudaSupport then
        lib.platforms.linux
      else
        lib.platforms.unix;
  };
}
