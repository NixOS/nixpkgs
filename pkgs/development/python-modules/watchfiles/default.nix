{
  lib,
  anyio,
  buildPythonPackage,
  dirty-equals,
  fetchFromGitHub,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  rustPlatform,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "watchfiles";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "watchfiles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gfH/8o3WsGL4Qki5kRrWpQLyk85HgTtR6iImInPYthg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-GFGhEXW0M23G0NB4Bu1FXV9Bmdt9weznHHSD/6rBSjI=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ anyio ];

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

  preCheck = ''
    rm -rf watchfiles
  '';

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn10Warning"
  ];

  disabledTests = [
    #  BaseExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_awatch_interrupt_raise"
  ];

  pythonImportsCheck = [ "watchfiles" ];

  meta = {
    description = "File watching and code reload";
    homepage = "https://watchfiles.helpmanual.io/";
    changelog = "https://github.com/samuelcolvin/watchfiles/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "watchfiles";
  };
})
