{ lib
, stdenv
, buildPythonPackage
, cython
, ninja
, setuptools-scm
, setuptools
, fetchPypi
, gn
, pytestCheckHook
, xcodebuild
, ApplicationServices
, OpenGL
}:

buildPythonPackage rec {
  pname = "skia-pathops";
  version = "0.7.4";

  src = fetchPypi {
    pname = "skia-pathops";
    inherit version;
    extension = "zip";
    sha256 = "sha256-Ci/e6Ht62wGMv6bpXvnkKZ7WOwCAvidnejD/77ypE1A=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "build_cmd = [sys.executable, build_skia_py, build_dir]" \
        'build_cmd = [sys.executable, build_skia_py, "--no-fetch-gn", "--no-virtualenv", "--gn-path", "${gn}/bin/gn", build_dir]'
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    substituteInPlace src/cpp/skia-builder/skia/gn/skia/BUILD.gn \
      --replace "-march=armv7-a" "-march=armv8-a" \
      --replace "-mfpu=neon" "" \
      --replace "-mthumb" ""
    substituteInPlace src/cpp/skia-builder/skia/src/core/SkOpts.cpp \
      --replace "defined(SK_CPU_ARM64)" "0"
  '';

  nativeBuildInputs = [ cython ninja setuptools-scm ]
    ++ lib.optionals stdenv.isDarwin [ xcodebuild ];

  buildInputs = lib.optionals stdenv.isDarwin [ ApplicationServices OpenGL ];

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pathops" ];

  meta = {
    description = "Python access to operations on paths using the Skia library";
    homepage = "https://skia.org/dev/present/pathops";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.BarinovMaxim ];
  };
}
