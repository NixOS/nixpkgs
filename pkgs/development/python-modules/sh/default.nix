{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sh";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amoffat";
    repo = "sh";
    tag = version;
    hash = "sha256-xtrT8fac7eJeGZ15yQqdYUqILcY1jUCVajX/j0ljl7Q=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests" ];

  # A test needs the HOME directory to be different from $TMPDIR.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Disable tests that fail on Hydra
    "test_no_fd_leak"
    "test_piped_exception1"
    "test_piped_exception2"
    "test_unicode_path"
    # fails to import itself after modifying the environment
    "test_environment"
    # timing sensitive due to strict timeouts
    "test_done_callback_no_deadlock"
    "test_timeout_overstep"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Disable tests that fail on Darwin sandbox
    "test_background_exception"
    "test_cwd"
    "test_ok_code"
  ];

  meta = {
    description = "Python subprocess interface";
    homepage = "https://pypi.org/project/sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
}
