{
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
  setuptools-scm,
  socat,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "serialx";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "puddly";
    repo = "serialx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vUz+theuNFrTX/g0SvdJxle7fAI9b517o3df9RP2MBY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-mI/6Buuk0VMofcD2LmE3+FpZhISAMzSYxe2IDC2iyAE=";
  };

  build-system = [
    setuptools
    setuptools-rust
    setuptools-scm
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "serialx" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    socat
  ];

  meta = {
    changelog = "https://github.com/puddly/serialx/releases/tag/${finalAttrs.src.tag}";
    description = "Serial library with native async support for Windows and POSIX";
    homepage = "https://github.com/puddly/serialx";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
