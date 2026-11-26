{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  sphinx,
  stdenv,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "curio";
  version = "1.6-unstable-2025-12-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dabeaz";
    repo = "curio";
    rev = "c29701fbb8d0a7b8f28ea60639b36b75f5550366";
    hash = "sha256-jnVyVPIczQs0Ec29HaB8cqL3EILfN5NF5+IkVMspFyo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_cpu" # timing sensitive
    "test_aside_basic" # times out
    "test_write_timeout" # flaky, does not always time out
    "test_aside_cancel" # fails because modifies PYTHONPATH and cant find pytest
    "test_ssl_outgoing" # touches network
    "test_unix_echo" # socket bind error on hydra when built with other packages
    "test_unix_ssl_server" # socket bind error on hydra when built with other packages
    "test_task_group_thread" # stuck
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # connects to python.org:1, expects an OsError, hangs in the darwin sandbox
    "test_create_bad_connection"
  ];

  pythonImportsCheck = [ "curio" ];

  # curio does not package new releaseas any more
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Library for performing concurrent I/O with coroutines in Python";
    homepage = "https://github.com/dabeaz/curio";
    changelog = "https://github.com/dabeaz/curio/raw/${src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
