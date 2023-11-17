{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv

# build-system
, setuptools

# dependencies
, braceexpand
, numpy
, pyyaml

# tests
, imageio
, lmdb
, msgpack
, pillow
, pytestCheckHook
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "webdataset";
  version = "0.2.77";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdataset";
    repo = "webdataset";
    rev = version;
    hash = "sha256-RhID5K80xSrd96PJsMRwKTQSQxdKhss9HobRrLC1Q5o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    braceexpand
    numpy
    pyyaml
  ];

  pythonImportsCheck = [
    "webdataset"
  ];

  nativeCheckInputs = [
    imageio
    lmdb
    msgpack
    pillow
    pytestCheckHook
    torch
    torchvision
  ];

  disabledTests = [
    # require network access
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
    "test_unbatched"
    "test_yaml3"
  ] ++ lib.optionals (stdenv.isAarch64) [
    # dataloader crashes
    "test_webloader"
    "test_webloader2"
    "test_webloader_repeat"
    "test_webloader_unbatched"
  ];

  meta = with lib; {
    changelog = "https://github.com/webdataset/webdataset/releases/tag/${version}";
    description = "A high-performance Python-based I/O system for large (and small) deep learning problems, with strong support for PyTorch";
    homepage = "https://github.com/webdataset/webdataset";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
