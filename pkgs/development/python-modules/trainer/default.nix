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
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "idiap";
    repo = "coqui-ai-Trainer";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lZmRniy8M3vsh0gCip9Eg0CwgDwcZnY1quy1VwU0O5I=";
=======
    hash = "sha256-vEVFnGn25F2lxG+oQzZWk20MarZdJrRkbsVC1rlEJwA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "General purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/idiap/coqui-ai-Trainer";
    changelog = "https://github.com/idiap/coqui-ai-Trainer/releases/tag/v${version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.tts ];
=======
  meta = with lib; {
    description = "General purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/idiap/coqui-ai-Trainer";
    changelog = "https://github.com/idiap/coqui-ai-Trainer/releases/tag/v${version}";
    license = licenses.asl20;
    teams = [ teams.tts ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
