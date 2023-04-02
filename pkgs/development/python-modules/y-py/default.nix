{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, rustPlatform
, libiconv
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "y-py";
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "y_py";
    inherit version;
    hash = "sha256-RoNhaffcKVffhRPP5LwgCRdbOkc+Ywr0IajnXuHEj5g=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-tpUDGBIHqXsKPsK+1h2sNuiV2I0pGVBokKh+hdFazRQ=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    rust.cargo
    rust.rustc
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  pythonImportsCheck = [ "y_py" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python bindings for Y-CRDT";
    homepage = "https://github.com/y-crdt/ypy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
