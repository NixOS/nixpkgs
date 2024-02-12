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
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "6.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    rev = "refs/tags/v${version}";
    hash = "sha256-fciNaVw603FAcgrSrND+LEycJffmnFQij2ZpatYZ/e4=";
  };

  passthru.optional-dependencies = {
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
  };

  pythonImportsCheck = [
    "smart_open"
  ];

  nativeCheckInputs = [
    moto
    pytestCheckHook
    responses
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
