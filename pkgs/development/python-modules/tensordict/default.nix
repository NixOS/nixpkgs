{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  cmake,

  # dependencies
  cloudpickle,
  importlib-metadata,
  numpy,
  orjson,
  packaging,
  torch,

  # tests
  h5py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tensordict";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensordict";
    tag = "v${version}";
    hash = "sha256-ZYuu1vKhC5Yi9m3EsPUhA9OXHjmHafUJRCDnQIu5kFk=";
  };

  # TODO: remove at next release
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'version = "0.8.0"' \
        'version = "0.8.1"'
  '';

  build-system = [
    pybind11
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cmake
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    cloudpickle
    importlib-metadata
    numpy
    orjson
    packaging
    torch
  ];

  pythonImportsCheck = [ "tensordict" ];

  # We have to delete the source because otherwise it is used instead of the installed package.
  preCheck = ''
    rm -rf tensordict
  '';

  nativeCheckInputs = [
    h5py
    pytestCheckHook
  ];

  disabledTests = [
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/source/tensordict/tensorclass.pyi
    "test_tensorclass_instance_methods"
    "test_tensorclass_stub_methods"

    # hangs forever on some CPUs
    "test_map_iter_interrupt_early"
  ];

  disabledTestPaths =
    [
      # torch._dynamo.exc.Unsupported: Graph break due to unsupported builtin None.ReferenceType.__new__.
      "test/test_compile.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Hangs forever
      "test/test_distributed.py"
    ];

  meta = {
    description = "Pytorch dedicated tensor container";
    changelog = "https://github.com/pytorch/tensordict/releases/tag/${src.tag}";
    homepage = "https://github.com/pytorch/tensordict";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
