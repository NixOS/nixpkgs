{ boto3
, buildPythonPackage
, crc32c
, fetchFromGitHub
, lib
, matplotlib
, moto
, numpy
, protobuf
, pytestCheckHook
, torch
, setuptools-scm
, soundfile
, stdenv
, tensorboard
, torchvision
}:

buildPythonPackage rec {
  pname = "tensorboardx";
  version = "2.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    rev = "refs/tags/v${version}";
    hash = "sha256-m7RLDOMuRNLacnIudptBGjhcTlMk8+v/onz6Amqxb90=";
  };

  nativeBuildInputs = [
    protobuf
    setuptools-scm
  ];

  # required to make tests deterministic
  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  propagatedBuildInputs = [
    crc32c
    numpy
  ];

  pythonImportsCheck = [ "tensorboardX" ];

  nativeCheckInputs = [
    boto3
    matplotlib
    moto
    pytestCheckHook
    soundfile
    torch
    tensorboard
    torchvision
  ];

  disabledTests = [
    # ImportError: Visdom visualization requires installation of Visdom
    "test_TorchVis"
    # Requires network access (FileNotFoundError: [Errno 2] No such file or directory: 'wget')
    "test_onnx_graph"
  ] ++ lib.optionals stdenv.isDarwin [
    # Fails with a mysterious error in pytorch:
    # RuntimeError: required keyword attribute 'name' has the wrong type
    "test_pytorch_graph"
  ];

  disabledTestPaths = [
    # we are not interested in linting errors
    "tests/test_lint.py"
    # ImportError: cannot import name 'mock_s3' from 'moto'
    "tests/test_embedding.py"
    "tests/test_record_writer.py"
  ];

  meta = with lib; {
    description = "Library for writing tensorboard-compatible logs";
    homepage = "https://tensorboardx.readthedocs.io";
    downloadPage = "https://github.com/lanpa/tensorboardX";
    changelog = "https://github.com/lanpa/tensorboardX/blob/${src.rev}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ lebastr akamaus ];
    platforms = platforms.all;
  };
}
