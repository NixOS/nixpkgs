{
  lib,
  buildPythonPackage,
  cmake,
  ninja,
  scikit-build-core,
  numpy,
  pillow,
  nanobind,
  libzxing-cpp,
  pytestCheckHook,
  libzint,
  python,
}:

buildPythonPackage {
  pname = "zxing-cpp";
  inherit (libzxing-cpp) src version;
  pyproject = true;

  sourceRoot = "${libzxing-cpp.src.name}/wrappers/python";

  dontUseCmakeConfigure = true;

  env = {
    nanobind_DIR = "${nanobind}/${python.sitePackages}/nanobind/cmake";
  };

  cmakeFlags = [
    (lib.cmakeBool "ZXING_USE_BUNDLED_ZINT" false)
  ];

  build-system = [
    scikit-build-core
    nanobind
  ];

  dependencies = [ numpy ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libzint
  ];

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
