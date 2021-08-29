{ boto3
, buildPythonPackage
, crc32c
, fetchFromGitHub
, lib
, matplotlib
, moto
, numpy
, pillow
, protobuf
, pytestCheckHook
, pytorch
, six
, soundfile
, tensorflow-tensorboard
, torchvision
}:

buildPythonPackage rec {
  pname = "tensorboardx";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    rev = "v${version}";
    sha256 = "1palz91y0b39pcmwg6wdmqfal38hai99dd6r88i3imqxdbmjghih";
  };

  # apparently torch API changed a bit at 1.6
  postPatch = ''
    substituteInPlace tensorboardX/pytorch_graph.py --replace \
      "torch.onnx.set_training(model, False)" \
      "torch.onnx.select_model_mode_for_export(model, torch.onnx.TrainingMode.EVAL)"
  '';

  propagatedBuildInputs = [
    crc32c
    numpy
    protobuf
    six
    soundfile
  ];

  checkInputs = [
    boto3
    matplotlib
    moto
    pillow
    pytestCheckHook
    pytorch
    tensorflow-tensorboard
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
