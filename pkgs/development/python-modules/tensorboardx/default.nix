{
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  matplotlib,
  moto,
  numpy,
  packaging,
  protobuf,
  pytestCheckHook,
  torch,
  setuptools,
  setuptools-scm,
  soundfile,
  stdenv,
  tensorboard,
  torchvision,
}:

buildPythonPackage rec {
  pname = "tensorboardx";
  version = "2.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    tag = "v${version}";
    hash = "sha256-GZQUJCiCKVthO95jHMIzNFcBM3R85BkyxO74CKCzizc=";
  };

  postPatch = ''
    # https://github.com/lanpa/tensorboardX/pull/761
    substituteInPlace tensorboardX/utils.py tests/test_utils.py \
      --replace-fail "newshape=" "shape="
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  # required to make tests deterministic
  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  dependencies = [
    packaging
    protobuf
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  meta = {
    description = "Library for writing tensorboard-compatible logs";
    homepage = "https://tensorboardx.readthedocs.io";
    downloadPage = "https://github.com/lanpa/tensorboardX";
    changelog = "https://github.com/lanpa/tensorboardX/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lebastr
      akamaus
    ];
    platforms = lib.platforms.all;
  };
}
