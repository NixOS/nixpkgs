{ lib
, stdenv
, buildPythonPackage
, braceexpand
, imageio
, lmdb
, msgpack
, numpy
, pytestCheckHook
, pyyaml
, setuptools
, torch
, torchvision
, wheel
, fetchFromGitHub
}:
buildPythonPackage rec {
  pname = "webdataset";
  version = "0.2.86";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdataset";
    repo = "webdataset";
    rev = "refs/tags/${version}";
    hash = "sha256-aTjxoSoQ9LH4gcFmV+7Aj0HNIpvsFHTrxFUpAtB3nkM=";
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

  disabledTests = [
    # requires network
    "test_batched"
    "test_dataloader"
    "test_decode_handlers"
    "test_decoder"
    "test_decoder"
    "test_download"
    "test_handlers"
    "test_pipe"
    "test_shard_syntax"
    "test_torchvision"
    "test_torchvision"
    "test_unbatched"
    "test_yaml3"
  ] ++ lib.optionals stdenv.isDarwin [
    # pickling error
    "test_background_download"
  ] ++ lib.optionals (stdenv.isAarch64 && stdenv.isLinux) [
    # segfaults on aarch64-linux
    "test_webloader"
    "test_webloader2"
    "test_webloader_repeat"
    "test_webloader_unbatched"
  ];

  meta = with lib; {
    description = "A high-performance Python-based I/O system for large (and small) deep learning problems, with strong support for PyTorch";
    homepage = "https://github.com/webdataset/webdataset";
    license = licenses.bsd3;
    maintainers = with maintainers; [ iynaix ];
  };
}
