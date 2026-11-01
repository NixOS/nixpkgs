{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  cmake,
  ninja,

  # dependencies
  cloudpickle,
  numpy,
  pyvers,
  torch,

  # tests
  h5py,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tensordict";
  version = "0.15.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensordict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CCTStWJub3RDYQHQH0zFJcqCvEWRNpTtdVTvRC/uOz8=";
  };

  build-system = [
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
    numpy
    pyvers
    torch
  ];

  pythonImportsCheck = [ "tensordict" ];

  # Prevent the source files from being imported at test time
  preCheck = ''
    rm -f tensordict/__init__.py
  '';

  nativeCheckInputs = [
    h5py
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Hangs forever
    "test/distributed/test_distributed.py"
  ];

  disabledTests = [
    # TypeError: not all arguments converted during string formatting
    "test_dtensor"

    # hangs forever on some CPUs
    "test_map_iter_interrupt_early"

    # AssertionError: assert 'a string!' == 'a metadata!'
    "test_save_load_memmap"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: Failed to initialize cpuinfo!
    "test_cast_filter_class_default"
    "test_cast_filter_inheritance"
    "test_cast_to"
    "test_casts"
    "test_dtype_shorthand_cast_filter"
    "test_td_params_cast"
    "test_to_dtype_cast_filter"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Hangs due to the use of a pool
    "test_chunksize_num_chunks"
    "test_index_with_generator"
    "test_map_exception"
    "test_map"
    "test_multiprocessing"
  ];

  meta = {
    description = "Pytorch dedicated tensor container";
    changelog = "https://github.com/pytorch/tensordict/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/pytorch/tensordict";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
