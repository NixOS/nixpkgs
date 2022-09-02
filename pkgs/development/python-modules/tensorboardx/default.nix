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
, protobuf3_8
, pytestCheckHook
, torch
, six
, soundfile
, tensorboard
, torchvision
}:

buildPythonPackage rec {
  pname = "tensorboardx";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    rev = "refs/tags/${version}";
    sha256 = "sha256-g6x0yUpofeSNA4rKPidqOKC7/TrOICstcc98VnQcfDY=";
  };

  # apparently torch API changed a bit at 1.6
  postPatch = ''
    substituteInPlace tensorboardX/pytorch_graph.py --replace \
      "torch.onnx.set_training(model, False)" \
      "torch.onnx.select_model_mode_for_export(model, torch.onnx.TrainingMode.EVAL)"
  '';

  # Wanted protobuf version is mentioned here:
  # https://github.com/lanpa/tensorboardX/blob/0d08112618a2bbda4c028a15a137fed3afe77401/compile.sh#L6
  nativeBuildInputs = [ which protobuf3_8 ];

  # required to make tests deterministic
  PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  propagatedBuildInputs = [
    crc32c
    numpy
    six
    soundfile
  ];

  checkInputs = [
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
