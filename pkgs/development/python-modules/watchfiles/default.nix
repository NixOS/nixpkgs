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
  CoreServices,
  libiconv,
}:

buildPythonPackage rec {
  pname = "watchfiles";
  version = "0.23.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kFScg3pkOD0gASRtfXSfwZxyW/XvW9x0zgMn0AQek4A=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-fg+uH/ATjIW67er7yZJLpnKOWremd+cPt5ksSAjv9xY=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  propagatedBuildInputs = [ anyio ];

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
