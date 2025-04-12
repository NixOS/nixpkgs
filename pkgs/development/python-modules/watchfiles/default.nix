{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  anyio,

  # tests
  dirty-equals,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "watchfiles";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "watchfiles";
    tag = "v${version}";
    hash = "sha256-0JBnUi/aRM9UFTkb8OkP9UkJV+BF2EieZptymRvAXc0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-5iJmtMnZKHAl/SkIjXlXkRA4ZME/ozpqFfxXKCAABoQ=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    anyio
  ];

  # Tests need these permissions in order to use the FSEvents API on macOS.
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.FSEvents"))
  '';

  nativeCheckInputs = [
    dirty-equals
    pytest-mock
    pytest-timeout
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  preCheck = ''
    rm -rf watchfiles
  '';

  disabledTests = [
    #  BaseExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_awatch_interrupt_raise"
  ];

  pythonImportsCheck = [ "watchfiles" ];

  meta = {
    description = "File watching and code reload";
    homepage = "https://watchfiles.helpmanual.io/";
    changelog = "https://github.com/samuelcolvin/watchfiles/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "watchfiles";
  };
}
