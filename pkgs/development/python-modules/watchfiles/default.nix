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
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.0.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "watchfiles";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UlQnCYSNU9H4x31KenSfYExGun94ekrOCwajORemSco=";
=======
    hash = "sha256-a6SHqYRNMGXNkVvwj9RpLj449dAQtWXO44v1ko5suaw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
<<<<<<< HEAD
    hash = "sha256-6sxtH7KrwAWukPjLSMAebguPmeAHbC7YHOn1QiRPigs=";
=======
    hash = "sha256-2RMWxeOjitbEqer9+ETpMX9WxHEiPzVmEv7LpSiaRVg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
