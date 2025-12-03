{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  awscli,
  azure-common,
  azure-core,
  azure-storage-blob,
  boto3,
  google-cloud-storage,
  requests,
  moto,
  numpy,
  paramiko,
  pytest-cov-stub,
  pytestCheckHook,
  pyopenssl,
  responses,
  setuptools,
  setuptools-scm,
  wrapt,
  zstandard,
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "7.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    tag = "v${version}";
    hash = "sha256-yrJmcwCVjPnkP8931xdb5fsOteBd+d/xEkg1/xahio8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
    awscli
    moto
    numpy
    pytest-cov-stub
    pytestCheckHook
    pyopenssl
    responses
  ]
  ++ moto.optional-dependencies.server
  ++ lib.concatAttrValues optional-dependencies;

  enabledTestPaths = [ "tests" ];

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
    homepage = "https://github.com/piskvorky/smart_open";
    license = licenses.mit;
  };
}
