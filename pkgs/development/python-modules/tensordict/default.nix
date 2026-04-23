{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  pybind11,
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  cmake,
  ninja,

  # dependencies
  cloudpickle,
  importlib-metadata,
  numpy,
  orjson,
  packaging,
  pyvers,
  torch,

  # tests
  h5py,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tensordict";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensordict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PUPDKv10Ks4B1kpgbRcnmfWFUkpFEdxMmTNztFVfdK4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11"
  '';

  build-system = [
    pybind11
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    cloudpickle
    importlib-metadata
    numpy
    orjson
    packaging
    pyvers
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
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AssertionError: assert 'a string!' == 'a metadata!'
    "test_save_load_memmap"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Hangs due to the use of a pool
    "test_chunksize_num_chunks"
    "test_index_with_generator"
    "test_map_exception"
    "test_map"
    "test_multiprocessing"
  ];

  disabledTestPaths = [
    # torch._dynamo.exc.Unsupported: Graph break due to unsupported builtin None.ReferenceType.__new__.
    "test/test_compile.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Hangs forever
    "test/test_distributed.py"
    # Hangs after testing due to pool usage
    "test/test_h5.py"
    "test/test_memmap.py"
  ];

  meta = {
    description = "Pytorch dedicated tensor container";
    changelog = "https://github.com/pytorch/tensordict/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/pytorch/tensordict";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
