{ lib
, buildPythonPackage
, fetchFromGitHub

, coqpit
, fsspec
, torch-bin
, tensorboard
, protobuf
, psutil

, pytestCheckHook
, soundfile
, torchvision-bin
}:

let
  pname = "trainer";
  version = "0.0.31";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    rev = "refs/tags/v${version}";
    hash = "sha256-avZuujeWG/UGkj7fcGB99Fw7KYktJPIDf8oB4wjoiD4=";
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
    tensorboard
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
