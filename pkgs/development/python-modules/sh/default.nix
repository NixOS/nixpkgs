{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, python
, lsof
, glibcLocales
, coreutils
, pytestCheckHook
 }:

buildPythonPackage rec {
  pname = "sh";
  version = "2.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "amoffat";
    repo = "sh";
    rev = "refs/tags/${version}";
    hash = "sha256-qMYaGNEvv2z47IHFGqb64TRpN3JHycpEmhYhDjrUi6s=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

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
  ] ++ lib.optionals stdenv.isDarwin [
    # Disable tests that fail on Darwin sandbox
    "test_background_exception"
    "test_cwd"
    "test_ok_code"
  ];

  meta = with lib; {
    description = "Python subprocess interface";
    homepage = "https://pypi.python.org/pypi/sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
