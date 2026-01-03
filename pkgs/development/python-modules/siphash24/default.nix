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

buildPythonPackage rec {
  version = "1.8";
  pname = "siphash24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnicolodi";
    repo = "python-siphash24";
    tag = "v${version}";
    hash = "sha256-51LgmB30MDTBRoZttIESopWMdrozvLFwlxYELmqu5UQ=";
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
    changelog = "https://github.com/dnicolodi/python-siphash24/releases/tag/${src.tag}";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
