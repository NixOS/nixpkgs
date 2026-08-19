{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.3.2";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "idiap";
    repo = "coqui-ai-Trainer";
    tag = "v${version}";
    hash = "sha256-lZmRniy8M3vsh0gCip9Eg0CwgDwcZnY1quy1VwU0O5I=";
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

  meta = {
    description = "General purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/idiap/coqui-ai-Trainer";
    changelog = "https://github.com/idiap/coqui-ai-Trainer/releases/tag/v${version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.tts ];
  };
}
