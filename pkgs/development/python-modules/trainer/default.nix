{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  hatchling,

  coqpit,
  fsspec,
  torch,
  tensorboard,
  protobuf,
  psutil,

  pytestCheckHook,
  soundfile,
  torchvision,
}:

let
  pname = "coqui-tts-trainer";
  version = "0.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "idiap";
    repo = "coqui-ai-Trainer";
    rev = "refs/tags/v${version}";
    hash = "sha256-zm8BTfXvfwuWpmHFcSxuu+/V4bKanSBU2dniQboVdLY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    coqpit
    fsspec
    protobuf
    psutil
    soundfile
    tensorboard
    torch
  ];

  # only one test and that requires training data from the internet
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    torchvision
  ];

  pythonImportsCheck = [ "trainer" ];

  meta = with lib; {
    description = "General purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/idiap/coqui-ai-Trainer";
    changelog = "https://github.com/idiap/coqui-ai-Trainer/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
