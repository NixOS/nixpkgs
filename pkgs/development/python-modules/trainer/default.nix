{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchpatch
, fetchFromGitHub
, pythonAtLeast
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

, coqpit
, fsspec
, torch-bin
<<<<<<< HEAD
, tensorboard
=======
, tensorboardx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, protobuf
, psutil

, pytestCheckHook
, soundfile
, torchvision-bin
}:

let
  pname = "trainer";
<<<<<<< HEAD
  version = "0.0.29";
=======
  version = "0.0.25";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ISEIIJReYKT3tEAF9/pckPg2+aYkBJyRWo6fvWZ/asI=";
=======
    hash = "sha256-XhE3CbcbCZjuUI6dx1gNNpQrxycqCgmOgjkaQ8MtL9E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i 's/^protobuf.*/protobuf/' requirements.txt
  '';

  propagatedBuildInputs = [
    coqpit
    fsspec
    protobuf
    psutil
    soundfile
<<<<<<< HEAD
    tensorboard
=======
    tensorboardx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    torch-bin
  ];

  # only one test and that requires training data from the internet
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    torchvision-bin
  ];

  pythonImportsCheck = [
    "trainer"
  ];

  meta = with lib; {
    description = "A general purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/coqui-ai/Trainer";
    changelog = "https://github.com/coqui-ai/Trainer/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
