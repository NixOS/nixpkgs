{ boto3
, buildPythonPackage
, crc32c
, which
, fetchFromGitHub
, lib
, matplotlib
, moto
, numpy
, pillow
, protobuf
, pytestCheckHook
, torch
, six
, soundfile
, tensorboard
, torchvision
}:

buildPythonPackage rec {
  pname = "tensorboardx";
  version = "2.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    rev = "refs/tags/v${version}";
    hash = "sha256-Np0Ibn51qL0ORwq1IY8lUle05MQDdb5XkI1uzGOKJno=";
  };

  # apparently torch API changed a bit at 1.6
  postPatch = ''
    substituteInPlace tensorboardX/pytorch_graph.py --replace \
      "torch.onnx.set_training(model, False)" \
      "torch.onnx.select_model_mode_for_export(model, torch.onnx.TrainingMode.EVAL)"

    # Version detection seems broken here, the version reported by python is
    # newer than the protobuf package itself.
    sed -i -e "s/'protobuf[^']*'/'protobuf'/" setup.py
  '';

  nativeBuildInputs = [
    which
    protobuf
  ];

  # required to make tests deterministic
  PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  propagatedBuildInputs = [
    crc32c
    numpy
    six
    soundfile
  ];

  nativeCheckInputs = [
    boto3
    matplotlib
    moto
    pillow
    pytestCheckHook
    torch
    tensorboard
    torchvision
  ];

  disabledTests = [
    # ImportError: Visdom visualization requires installation of Visdom
    "test_TorchVis"
    # Requires network access (FileNotFoundError: [Errno 2] No such file or directory: 'wget')
    "test_onnx_graph"
  ];

  disabledTestPaths = [
    # we are not interested in linting errors
    "tests/test_lint.py"
  ];

  meta = with lib; {
    description = "Library for writing tensorboard-compatible logs";
    homepage = "https://github.com/lanpa/tensorboardX";
    license = licenses.mit;
    maintainers = with maintainers; [ lebastr akamaus ];
    platforms = platforms.all;
  };
}
