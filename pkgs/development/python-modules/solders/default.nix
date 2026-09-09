{
  lib,
  buildPythonPackage,
  cargo,
  pkgs,
  fetchFromGitHub,
  jsonalias,
  openssl,
  pkg-config,
  rustc,
  rustPlatform,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "solders";
  version = "0.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kevinheavey";
    repo = "solders";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a3G3mMJvnO24w6WEJnEkYUNinXWHR26KupIlq5eik8A=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+8iaA1Cs+7qiDfQpwPAWSZ1HuF85WaDZB3MN57QOodI=";
  };

  pythonRelaxDeps = [ "jsonalias" ];

  build-system = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [
    openssl
    pkgs.zstd
  ];

  dependencies = [
    jsonalias
    typing-extensions
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    PKG_CONFIG_PATH = lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
      openssl
      pkgs.zstd
    ];
  };

  pythonImportsCheck = [ "solders" ];

  meta = {
    description = "Python toolkit for Solana";
    homepage = "https://github.com/kevinheavey/solders";
    changelog = "https://github.com/kevinheavey/solders/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
