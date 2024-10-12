{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
  rustc,
  libiconv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "y-py";
  version = "0.6.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "y_py";
    inherit version;
    hash = "sha256-R1eoKlBAags6MzqgEiAZozG9bxbkn+1n3KQj+Siz/U0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-RXwrDSPU0wiprsUJwoDzti14H/+bSwy4hK4tYhNVfYw=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  pythonImportsCheck = [ "y_py" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python bindings for Y-CRDT";
    homepage = "https://github.com/y-crdt/ypy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
