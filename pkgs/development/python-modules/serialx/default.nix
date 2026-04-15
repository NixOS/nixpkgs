{
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  lib,
  psutil,
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
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "puddly";
    repo = "serialx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7EtFGjcy9RWnbwRM6ptbBpeZDUw3ud4JvfMkuDru6i0=";
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
    psutil
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    socat
  ];

  disabledTests = [
    # tries to access /sys/class/tty in sandbox
    "test_compat_tools_module"
  ];

  meta = {
    changelog = "https://github.com/puddly/serialx/releases/tag/${finalAttrs.src.tag}";
    description = "Serial library with native async support for Windows and POSIX";
    homepage = "https://github.com/puddly/serialx";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
