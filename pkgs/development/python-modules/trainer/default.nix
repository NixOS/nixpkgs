{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, pythonAtLeast

, coqpit
, fsspec
, soundfile
, torch
, tensorboardx
, protobuf

, pytestCheckHook
, torchvision
}:

let
  pname = "trainer";
  version = "0.0.16";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    rev = "refs/tags/v${version}";
    hash = "sha256-G2qFQEO5OOEI2jsb+zXsO8cbC13o7pqAC2xkFrhGkLc=";
  };

  postPatch = ''
    sed -i 's/^protobuf.*/protobuf/' requirements.txt
  '';

  propagatedBuildInputs = [
    coqpit
    fsspec
    torch
    soundfile
    tensorboardx
    protobuf
  ];

  checkInputs = [
    pytestCheckHook
    torchvision
  ];

  disabledTests = [
    # tries to download training data
    "test_train_mnist"
    "test_continue_train"
  ];

  pythonImportsCheck = [
    "trainer"
  ];

  meta = with lib; {
    description = "A general purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/coqui-ai/Trainer";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
