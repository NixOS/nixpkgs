{
  buildPythonPackage,
  cmake,
  setuptools-scm,
  numpy,
  pillow,
  pybind11,
  libzxing-cpp,
  pytestCheckHook,
  libzint,
}:

buildPythonPackage rec {
  pname = "zxing-cpp";
  inherit (libzxing-cpp) src version meta;
  pyproject = true;

  sourceRoot = "${src.name}/wrappers/python";

  # we don't need pybind11 in the root environment
  # https://pybind11.readthedocs.io/en/stable/installing.html#include-with-pypi
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11"

    substituteInPlace setup.py \
      --replace-fail "cfg = 'Debug' if self.debug else 'Release'" "cfg = 'Release'" \
      --replace-fail " '-DVERSION_INFO=' + self.distribution.get_version()]" " '-DVERSION_INFO=' + self.distribution.get_version(), '-DZXING_DEPENDENCIES=LOCAL', '-DZXING_USE_BUNDLED_ZINT=OFF']"
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    setuptools-scm
    pybind11
  ];

  dependencies = [ numpy ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ libzint ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "zxingcpp" ];
}
