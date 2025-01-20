{
  lib,
  stdenv,
  anyio,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  pythonOlder,
  dirty-equals,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  typing-extensions,
  CoreServices,
  libiconv,
}:

buildPythonPackage rec {
  pname = "watchfiles";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-0JBnUi/aRM9UFTkb8OkP9UkJV+BF2EieZptymRvAXc0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreServices
    libiconv
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  build-system = [ rustPlatform.maturinBuildHook ];

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
  ];

  postPatch = ''
    sed -i "/^requires-python =.*/a version = '${version}'" pyproject.toml
  '';

  preCheck = ''
    rm -rf watchfiles
  '';

  disabledTests = [
    #  BaseExceptionGroup: unhandled errors in a TaskGroup (1 sub-exception)
    "test_awatch_interrupt_raise"
  ];

  pythonImportsCheck = [ "watchfiles" ];

  meta = with lib; {
    description = "File watching and code reload";
    mainProgram = "watchfiles";
    homepage = "https://watchfiles.helpmanual.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
