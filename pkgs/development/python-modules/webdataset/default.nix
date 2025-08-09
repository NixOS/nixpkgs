{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  braceexpand,
  numpy,
  pyyaml,

  # tests
  imageio,
  lmdb,
  msgpack,
  pytestCheckHook,
  torch,
  torchvision,
}:
buildPythonPackage rec {
  pname = "webdataset";
  version = "0.2.107";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdataset";
    repo = "webdataset";
    tag = "v${version}";
    hash = "sha256-L9RUQItmW/7O/eTst2Sl/415EP4Jo662bKWbYA6p5bk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    braceexpand
    numpy
    pyyaml
  ];

  nativeCheckInputs = [
    imageio
    lmdb
    msgpack
    pytestCheckHook
    torch
    torchvision
  ];

  pythonImportsCheck = [ "webdataset" ];

  preCheck = ''
    export WIDS_CACHE=$TMPDIR
  '';

  disabledTests = [
    # requires network
    "test_batched"
    "test_cache_dir"
    "test_concurrent_download_and_open"
    "test_dataloader"
    "test_decode_handlers"
    "test_decoder"
    "test_download"
    "test_handlers"
    "test_pipe"
    "test_remote_file"
    "test_shard_syntax"
    "test_torchvision"
    "test_unbatched"
    "test_yaml3"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # pickling error
    "test_background_download"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin) [
    "test_concurrent_access"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    # segfaults on aarch64-linux
    "test_webloader"
    "test_webloader2"
    "test_webloader_repeat"
    "test_webloader_unbatched"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Issue with creating a temp file in the sandbox
    "tests/wids/test_wids_mmtar.py"
    # hangs the build *after* the tests
    "tests/webdataset/test_loaders.py"
  ];

  meta = {
    description = "High-performance Python-based I/O system for large (and small) deep learning problems, with strong support for PyTorch";
    mainProgram = "widsindex";
    homepage = "https://github.com/webdataset/webdataset";
    changelog = "https://github.com/webdataset/webdataset/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iynaix ];
  };
}
