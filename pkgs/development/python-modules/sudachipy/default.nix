{ lib
, stdenv
, buildPythonPackage
, cargo
, libiconv
, rustPlatform
, rustc
, sudachi-rs
, setuptools-rust
, pytestCheckHook
, sudachidict-core
, tokenizers
}:

buildPythonPackage rec {
  pname = "sudachipy";
  inherit (sudachi-rs) src version;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Am+ae2lgnndSDzf0GF8R1i6OPLdIlm2dLThqYqXbscA=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools-rust
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  preBuild = ''
    cd python
  '';

  nativeCheckInputs = [
    pytestCheckHook
    sudachidict-core
    tokenizers
  ];

  pythonImportsCheck = [
    "sudachipy"
  ];

  meta = sudachi-rs.meta // {
    homepage = "https://github.com/WorksApplications/sudachi.rs/tree/develop/python";
    mainProgram = "sudachipy";
  };
}
