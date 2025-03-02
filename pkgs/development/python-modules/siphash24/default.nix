{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  meson,
  meson-python,
  cython,
  pkg-config,
  libcsiphash,
  libcstdaux,
  unittestCheckHook,
}:

buildPythonPackage rec {
  version = "1.7";
  pname = "siphash24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnicolodi";
    repo = "python-siphash24";
    tag = "v${version}";
    sha256 = "sha256-/7XrRD4e7jLTUY/8mBbJ4dSo5P6pj8GRpSreIOZpKp0=";
  };

  build-system = [
    meson
    meson-python
    cython
    pkg-config
  ];

  buildInputs = [
    libcsiphash
    libcstdaux
  ];

  pythonImportsCheck = [
    "siphash24"
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    homepage = "https://github.com/dnicolodi/python-siphash24";
    description = "Streaming-capable SipHash Implementation";
    changelog = "https://github.com/dnicolodi/python-siphash24/releases/tag/${src.tag}";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
