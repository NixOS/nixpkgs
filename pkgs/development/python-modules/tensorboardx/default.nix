{ boto3
, buildPythonPackage
, crc32c
, fetchFromGitHub
, fetchpatch
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
, stdenv
, tensorboard
, torchvision
, which
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

  patches = [
    (fetchpatch {
      name = "fix-test-multiprocess-fork-on-darwin.patch";
      url = "https://github.com/lanpa/tensorboardX/commit/246a867237ff12893351b9275a1e297ee2861319.patch";
      hash = "sha256-ObUaIi1gFcGZAvDOEtZFd9TjZZUp3k89tYwmDQ5yOWg=";
    })
    # https://github.com/lanpa/tensorboardX/pull/706
    (fetchpatch {
      name = "fix-test-use-matplotlib-agg-backend.patch";
      url = "https://github.com/lanpa/tensorboardX/commit/751821c7af7f7f2cb724938e36fa04e814c0e4de.patch";
      hash = "sha256-Tu76ZRTh8fGj+/CzpqJO65hKrDFASbmzoLVIZ0kyLQA=";
    })
    # https://github.com/lanpa/tensorboardX/pull/707
    (fetchpatch {
      name = "fix-test-handle-numpy-float128-missing.patch";
      url = "https://github.com/lanpa/tensorboardX/commit/38f57ffc3b3dd91e76b13ec97404278065fbc782.patch";
      hash = "sha256-5Po41lHiO5hKi4ZtWR98/wwDe9HKZdADNTv40mgIEvk=";
    })
    # https://github.com/lanpa/tensorboardX/pull/708
    (fetchpatch {
      name = "fix-test-respect-tmpdir.patch";
      url = "https://github.com/lanpa/tensorboardX/commit/b0191d1cfb8a23def76e465d20fd59302c894f32.patch";
      hash = "sha256-6rSncJ16P1u70Cz9nObo8lMD7Go50BR3DZLgP4bODk4=";
    })
  ];

  postPatch = ''
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
  ] ++ lib.optionals stdenv.isDarwin [
    # Fails with a mysterious error in pytorch:
    # RuntimeError: required keyword attribute 'name' has the wrong type
    "test_pytorch_graph"
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
