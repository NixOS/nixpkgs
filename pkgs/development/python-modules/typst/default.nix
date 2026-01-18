{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "typst";
  version = "0.14.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "messense";
    repo = "typst-py";
    tag = "v${version}";
    hash = "sha256-Slo9cstmh9ZjxcqVdRldU+n82JK1cGf89cHE9Rrh7z0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-haEthOKjyQkHhPgYPo40uLjfv29BDCC084KWmGRwkVk=";
  };

  build-system = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "typst" ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Python binding to typst";
    homepage = "https://github.com/messense/typst-py";
    changelog = "https://github.com/messense/typst-py/releases/tag/v${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
