{ lib
, stdenv
, anyio
, buildPythonPackage
, cargo
, fetchFromGitHub
, rustPlatform
, rustc
, pythonOlder
, dirty-equals
, pytest-mock
, pytest-timeout
, pytestCheckHook
, CoreServices
, libiconv
, freebsd
}:

buildPythonPackage rec {
  pname = "watchfiles";
  version = "0.21.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/qNgkPF5N8jzSV3M0YFWvQngZ4Hf4WM/GBS1LtgFbWM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-sqHTW1+E7Fp33KW6IYlNa77AYc2iCfaSoBRXzrhEKr8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ] ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    freebsd.libexecinfo freebsd.libkvm freebsd.libmemstat freebsd.libprocstat freebsd.libdevstat
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  propagatedBuildInputs = [
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
  ] ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    # TODO @rhelmot triage. possibly enum mismatches or backend differences?
    "test_modify_write_non_recursive"
    "test_add_non_recursive"
    "test_delete"
    "test_delete_non_recursive"
    "test_move_out"
    "test_move_internal"
    # raises wrong error
    "test_does_not_exist"
  ];

  pythonImportsCheck = [
    "watchfiles"
  ];

  meta = with lib; {
    description = "File watching and code reload";
    homepage = "https://watchfiles.helpmanual.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
