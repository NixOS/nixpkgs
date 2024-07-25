{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  skia,
  numpy,
  pybind11,
  freetype,
  fontconfig,
  vulkan-headers,
  expat,
  libGL,
}:

buildPythonPackage rec {
  pname = "skia-python";
  version = "124.0b7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kyamagu";
    repo = "skia-python";
    rev = "v${version}";
    hash = "sha256-BXbucbVSVDIQCy4Kk4d1cF7pjX8tXYoqENjyuOVsE3o=";
  };

  patches = [
    ./link-libs.patch
  ];

  postPatch = ''
    substituteInPlace src/skia/Font.cpp \
      --replace '"include/ports/SkFontMgr_fontconfig.h"' '<include/ports/SkFontMgr_fontconfig.h>'

    substituteInPlace src/skia/main.cpp \
      --replace '"include/core/SkGraphics.h"' '<include/core/SkGraphics.h>'

    substituteInPlace src/skia/* \
      --replace "<include/" "<"
  '';

  build-system = [
    setuptools
    setuptools-scm
    pybind11
  ];

  dependencies = [
    numpy
    pybind11
  ];

  buildInputs = [
    skia
    freetype
    fontconfig
    vulkan-headers
    expat
    libGL
  ];

  meta = {
    description = "Python binding to Skia Graphics Library";
    homepage = "https://github.com/kyamagu/skia-python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
