{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, azure-common
, azure-core
, azure-storage-blob
, boto3
, google-cloud-storage
, requests
, moto
, paramiko
, pytestCheckHook
, responses
, setuptools
, wrapt
, zstandard
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    rev = "refs/tags/v${version}";
    hash = "sha256-yGy4xNoHCE+LclBBTMVtTKP6GYZ5w09NJ0OmsUPnir4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    wrapt
  ];

  optional-dependencies = {
    s3 = [
      boto3
    ];
    gcs = [
      google-cloud-storage
    ];
    azure = [
      azure-storage-blob
      azure-common
      azure-core
    ];
    http = [
      requests
    ];
    webhdfs = [
      requests
    ];
    ssh = [
      paramiko
    ];
    zst = [
      zstandard
    ];
  };

  pythonImportsCheck = [
    "smart_open"
  ];

  nativeCheckInputs = [
    moto
    pytestCheckHook
    responses
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pytestFlagsArray = [
    "smart_open"
  ];

  disabledTests = [
    # https://github.com/RaRe-Technologies/smart_open/issues/784
    "test_https_seek_forward"
    "test_seek_from_current"
    "test_seek_from_end"
    "test_seek_from_start"
  ];

  meta = with lib; {
    description = "Library for efficient streaming of very large file";
    homepage = "https://github.com/RaRe-Technologies/smart_open";
    license = licenses.mit;
    maintainers = with maintainers; [ jyp ];
  };
}
