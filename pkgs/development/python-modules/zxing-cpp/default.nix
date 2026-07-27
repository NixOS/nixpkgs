{
  buildPythonPackage,
  cmake,
  setuptools-scm,
  numpy,
  pillow,
  pybind11,
  libzxing-cpp,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  libzint,
}:

buildPythonPackage {
  pname = "zxing-cpp";
  inherit (libzxing-cpp) src version;
  pyproject = true;

  sourceRoot = "${libzxing-cpp.src.name}/wrappers/python";

  # we don't need pybind11 in the root environment
  # https://pybind11.readthedocs.io/en/stable/installing.html#include-with-pypi
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11"

    substituteInPlace setup.py \
      --replace-fail "cfg = 'Debug' if self.debug else 'Release'" "cfg = 'Release'" \
      --replace-fail "f'-DPython_EXECUTABLE={sys.executable}'," "f'-DPython_EXECUTABLE={sys.executable}', '-DZXING_DEPENDENCIES=LOCAL', '-DZXING_USE_BUNDLED_ZINT=OFF',"
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    setuptools-scm
    pybind11
  ];

  dependencies = [ numpy ];

  nativeBuildInputs = [
    cmake
    pyprojectVersionPatchHook
  ];

  buildInputs = [ libzint ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "zxingcpp" ];

  meta = {
    inherit (libzxing-cpp.meta)
      homepage
      changelog
      description
      longDescription
      license
      maintainers
      platforms
      ;
  };
}
