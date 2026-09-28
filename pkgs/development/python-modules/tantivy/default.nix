{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  pkg-config,

  # tests
  mktestdocs,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tantivy";
  version = "0.26.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "quickwit-oss";
    repo = "tantivy-py";
    tag = finalAttrs.version;
    hash = "sha256-yxRwN4rR9RQKvXxPcg1bTOfmtt9bV4y8dMn54qKuUi8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-uzhP5DoAiZ9cUuxmE9l805q26XHZh70eREFqpxHEIWg=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    pkgs.zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  pythonImportsCheck = [ "tantivy" ];

  preCheck = ''
    rm -rf tantivy
  '';

  nativeCheckInputs = [
    mktestdocs
    pytestCheckHook
  ];

  meta = {
    description = "Official Python bindings for the Tantivy search engine";
    homepage = "https://pypi.org/project/tantivy";
    changelog = "https://github.com/quickwit-oss/tantivy-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
