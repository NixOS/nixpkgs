{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  pname = "trainer";
  version = "0.0.36";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    rev = "refs/tags/v${version}";
    hash = "sha256-z6TOzWqE3NytkdG3nUzh9GpFVGQEXFyzSQ8gvdB4wiw=";
  };

  patches = [
    (fetchpatch {
      name = "add-support-for-python312.patch";
      hash = "sha256-V5RPn/2pGKzQrf/SIRU3imo6nBhpBEJpI7HsFYbVZj4=";
      url = "https://github.com/coqui-ai/Trainer/commit/0278012c7e6f5972b656d11757add4ab89f6d272.patch";
    })
  ];

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
    homepage = "https://github.com/coqui-ai/Trainer";
    changelog = "https://github.com/coqui-ai/Trainer/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
