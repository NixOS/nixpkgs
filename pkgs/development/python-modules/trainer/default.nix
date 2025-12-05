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
  version = "0.3.1";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "idiap";
    repo = "coqui-ai-Trainer";
    tag = "v${version}";
    hash = "sha256-vEVFnGn25F2lxG+oQzZWk20MarZdJrRkbsVC1rlEJwA=";
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
    teams = [ teams.tts ];
  };
}
