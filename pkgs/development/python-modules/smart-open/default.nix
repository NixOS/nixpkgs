{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  azure-common,
  azure-core,
  azure-storage-blob,
  boto3,
  google-cloud-storage,
  requests,
  moto,
  paramiko,
  pytestCheckHook,
  responses,
  setuptools,
  wrapt,
  zstandard,
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "7.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    tag = "v${version}";
    hash = "sha256-ANbM0bKmkK25WCKxV7KHlPjzfTAY7dP67mmahRwtXI8=";
  };

  build-system = [ setuptools ];

  dependencies = [ wrapt ];

  optional-dependencies = {
    s3 = [ boto3 ];
    gcs = [ google-cloud-storage ];
    azure = [
      azure-storage-blob
      azure-common
      azure-core
    ];
    http = [ requests ];
    webhdfs = [ requests ];
    ssh = [ paramiko ];
    zst = [ zstandard ];
  };

  pythonImportsCheck = [ "smart_open" ];

  nativeCheckInputs = [
    moto
    pytestCheckHook
    responses
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [ "smart_open" ];

  disabledTests = [
    # https://github.com/RaRe-Technologies/smart_open/issues/784
    "test_https_seek_forward"
    "test_seek_from_current"
    "test_seek_from_end"
    "test_seek_from_start"
  ];

  meta = with lib; {
    changelog = "https://github.com/piskvorky/smart_open/releases/tag/${src.tag}";
    description = "Library for efficient streaming of very large file";
    homepage = "https://github.com/RaRe-Technologies/smart_open";
    license = licenses.mit;
    maintainers = with maintainers; [ jyp ];
  };
}
