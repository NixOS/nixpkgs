{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchPypi,
  libiconv,
  Foundation,
  rustPlatform,
  rustc,
  setuptools-rust,
  range-typed-integers,
}:

buildPythonPackage rec {
  pname = "skytemple-rust";
  version = "1.6.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bf+umrb5EIoCD2kheVpf9IwsW4Sf2hR7XOEzscYtLA8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-0a57RmZPztcIeRs7GNYe18JO+LlWoeNWG3nD9cG0XIU=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Foundation
  ];
  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];
  propagatedBuildInputs = [ range-typed-integers ];

  GETTEXT_SYSTEM = true;

  doCheck = false; # tests for this package are in skytemple-files package
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    description = "Binary Rust extensions for SkyTemple";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
