{
  lib,
  awscli2,
  azure-common,
  azure-core,
  azure-storage-blob,
  backports-zstd,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  google-cloud-storage,
  lz4,
  moto,
  numpy,
  paramiko,
  pyopenssl,
  pytest-cov-stub,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  requests,
  responses,
  setuptools-scm,
  setuptools,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "smart-open";
  version = "10.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piskvorky";
    repo = "smart_open";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WFI8391MK/fg5e3QEMeMWy4eyFVHB8h6MGxJ+lSpsNY=";
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
    lz4 = [ lz4 ];
    webhdfs = [ requests ];
    ssh = [ paramiko ];
    zst = [ backports-zstd ];
  };

  pythonImportsCheck = [ "smart_open" ];

  nativeCheckInputs = [
    awscli2
    moto
    numpy
    pytest-cov-stub
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    pyopenssl
    responses
  ]
  ++ moto.optional-dependencies.server
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # https://github.com/piskvorky/smart_open/issues/784
    "test_https_seek_forward"
    "test_seek_from_current"
    "test_seek_from_end"
    "test_seek_from_start"
  ];

  meta = {
    description = "Library for efficient streaming of very large file";
    homepage = "https://github.com/piskvorky/smart_open";
    changelog = "https://github.com/piskvorky/smart_open/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
