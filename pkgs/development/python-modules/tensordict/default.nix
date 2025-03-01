{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  torch,

  # dependencies
  cloudpickle,
  numpy,
  orjson,
  packaging,

  # tests
  h5py,
  pytestCheckHook,

  stdenv,
}:

buildPythonPackage rec {
  pname = "tensordict";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensordict";
    tag = "v${version}";
    hash = "sha256-ZDfRvfyBashU4kIoo8JX/EoCv4tpDOyggOlpdVCudT8=";
  };

  build-system = [
    setuptools
    torch
  ];

  dependencies = [
    cloudpickle
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
      # ModuleNotFoundError: No module named 'torch._C._distributed_c10d'; 'torch._C' is not a package
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
