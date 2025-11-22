{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  curl,

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
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdataset";
    repo = "webdataset";
    # recent versions are not tagged on GitHub
    rev = "0773837ecd298587fc89c4f944ef346ef1a6b619";
    hash = "sha256-jFFRp5W9yP1mKi9x43EdOakFAd9ArnDqH3dnvFOeCmc=";
  };

  postPatch = ''
    substituteInPlace src/webdataset/gopen.py \
      --replace-fail \
        '"curl"' \
        '"${lib.getExe curl}"'
  '';

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

  disabledTests = [
    # Require network
    "test_batched"
    "test_cache_dir"
    "test_dataloader"
    "test_decode_handlers"
    "test_decoder"
    "test_handlers"
    "test_pipe"
    "test_remote_file"
    "test_shard_syntax"
    "test_torchvision"
    "test_unbatched"
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
