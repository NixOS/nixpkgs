{
  lib,
  stdenv,
  buildPythonPackage,
  braceexpand,
  imageio,
  lmdb,
  msgpack,
  numpy,
  pytestCheckHook,
  pyyaml,
  setuptools,
  torch,
  torchvision,
  wheel,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "webdataset";
  version = "0.2.90";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdataset";
    repo = "webdataset";
    rev = "refs/tags/${version}";
    hash = "sha256-selj7XD7NS831lbPnx/4o46bNpsxuFdSEIIb4S2b7S0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    braceexpand
    numpy
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    imageio
    torch
    torchvision
    msgpack
    lmdb
  ];

  pythonImportsCheck = [ "webdataset" ];

  disabledTests =
    [
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
    ++ lib.optionals stdenv.isDarwin [
      # pickling error
      "test_background_download"
    ]
    ++ lib.optionals (stdenv.isx86_64 && stdenv.isDarwin) [
      "test_concurrent_access"
      # fails to patch 'init_process_group' from torch.distributed
      "TestDistributedChunkedSampler"
    ]
    ++ lib.optionals (stdenv.isAarch64 && stdenv.isLinux) [
      # segfaults on aarch64-linux
      "test_webloader"
      "test_webloader2"
      "test_webloader_repeat"
      "test_webloader_unbatched"
    ];

  meta = with lib; {
    description = "A high-performance Python-based I/O system for large (and small) deep learning problems, with strong support for PyTorch";
    mainProgram = "widsindex";
    homepage = "https://github.com/webdataset/webdataset";
    changelog = "https://github.com/webdataset/webdataset/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ iynaix ];
  };
}
