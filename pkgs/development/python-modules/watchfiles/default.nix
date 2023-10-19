{ lib
, stdenv
, anyio
, buildPythonPackage
, cargo
, fetchFromGitHub
, rustPlatform
, rustc
, setuptools-rust
, pythonOlder
, dirty-equals
, pytest-mock
, pytest-timeout
, pytestCheckHook
, python
, CoreServices
, libiconv
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
