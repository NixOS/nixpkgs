{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  meson,
  meson-python,
  cython,
  pkg-config,
  c-siphash,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  version = "1.9";
  pname = "siphash24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnicolodi";
    repo = "python-siphash24";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V279CjIeSJvhgBYwbMAw8PaguLpCuYCec6fD8agFZTg=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [
    meson
    meson-python
    cython
  ];

  buildInputs = [
    c-siphash
  ];

  pythonImportsCheck = [
    "siphash24"
  ];

  enabledTestPaths = [ "test.py" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/dnicolodi/python-siphash24";
    description = "Streaming-capable SipHash Implementation";
    changelog = "https://github.com/dnicolodi/python-siphash24/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
