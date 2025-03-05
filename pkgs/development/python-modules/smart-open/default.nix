{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
  azure-common,
  azure-core,
  azure-storage-blob,
  boto3,
  google-cloud-storage,
  requests,
  moto,
  paramiko,
  pynacl,
  pytestCheckHook,
  responses,
  setuptools,
  wrapt,
  zstandard,
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "7.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    rev = "refs/tags/v${version}";
    hash = "sha256-4HOTaF6AKXGlVCvSGKnnaH73aa4IO0aRxz03XQ4gSd8=";
  };

  patches = [
    # https://github.com/RaRe-Technologies/smart_open/pull/822
    # fix test_smart_open.py on python 3.12
    (fetchpatch {
      name = "fix-smart-open-test.patch";
      url = "https://github.com/RaRe-Technologies/smart_open/commit/3d29564ca034a56d343c9d14b178aaa0ff4c937c.patch";
      hash = "sha256-CrAeqaIMM8bctWiFnq9uamnIlkaslDyjaWL6k9wUjT8=";
    })
  ];

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
    pynacl
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pytestFlagsArray = [ "smart_open" ];

  disabledTests = [
    # https://github.com/RaRe-Technologies/smart_open/issues/784
    "test_https_seek_forward"
    "test_seek_from_current"
    "test_seek_from_end"
    "test_seek_from_start"
  ];

  meta = with lib; {
    changelog = "https://github.com/piskvorky/smart_open/releases/tag/v${version}";
    description = "Library for efficient streaming of very large file";
    homepage = "https://github.com/RaRe-Technologies/smart_open";
    license = licenses.mit;
    maintainers = with maintainers; [ jyp ];
  };
}
