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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Wh25tLOVhAYFLqjOrKSu4klB1hGSOMconC1xZG31Dbw=";
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
