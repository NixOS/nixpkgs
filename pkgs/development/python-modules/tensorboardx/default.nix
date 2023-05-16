{ boto3
, buildPythonPackage
, crc32c
<<<<<<< HEAD
=======
, which
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, lib
, matplotlib
, moto
, numpy
<<<<<<< HEAD
, protobuf
, pytestCheckHook
, torch
, setuptools-scm
, soundfile
, stdenv
=======
, pillow
, protobuf
, pytestCheckHook
, torch
, six
, soundfile
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, tensorboard
, torchvision
}:

buildPythonPackage rec {
  pname = "tensorboardx";
<<<<<<< HEAD
  version = "2.6.2";
=======
  version = "2.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lanpa";
    repo = "tensorboardX";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-m7RLDOMuRNLacnIudptBGjhcTlMk8+v/onz6Amqxb90=";
  };

  nativeBuildInputs = [
    protobuf
    setuptools-scm
  ];

  # required to make tests deterministic
  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    crc32c
    numpy
<<<<<<< HEAD
  ];

  pythonImportsCheck = [ "tensorboardX" ];

=======
    six
    soundfile
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    boto3
    matplotlib
    moto
<<<<<<< HEAD
    pytestCheckHook
    soundfile
=======
    pillow
    pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    torch
    tensorboard
    torchvision
  ];

  disabledTests = [
    # ImportError: Visdom visualization requires installation of Visdom
    "test_TorchVis"
    # Requires network access (FileNotFoundError: [Errno 2] No such file or directory: 'wget')
    "test_onnx_graph"
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    # Fails with a mysterious error in pytorch:
    # RuntimeError: required keyword attribute 'name' has the wrong type
    "test_pytorch_graph"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTestPaths = [
    # we are not interested in linting errors
    "tests/test_lint.py"
  ];

  meta = with lib; {
    description = "Library for writing tensorboard-compatible logs";
<<<<<<< HEAD
    homepage = "https://tensorboardx.readthedocs.io";
    downloadPage = "https://github.com/lanpa/tensorboardX";
    changelog = "https://github.com/lanpa/tensorboardX/blob/${src.rev}/HISTORY.rst";
=======
    homepage = "https://github.com/lanpa/tensorboardX";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ lebastr akamaus ];
    platforms = platforms.all;
  };
}
