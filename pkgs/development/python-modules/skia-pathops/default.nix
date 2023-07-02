{ lib
, ApplicationServices
, OpenGL
, buildPythonPackage
, cython
, fetchPypi
, gn
, isPyPy
, ninja
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, stdenv
, xcodebuild
}:

buildPythonPackage rec {
  pname = "skia-pathops";
  version = "0.8.0";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "skia-pathops";
    inherit version;
    extension = "zip";
    hash = "sha256-0SrxzvKL5KbzNgZdBtMeO006bCKFB6gdOgxZbXignO4=";
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
    homepage = "https://github.com/fonttools/skia-pathops";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.BarinovMaxim ];
    # ERROR at //gn/BUILDCONFIG.gn:87:14: Script returned non-zero exit code.
    broken = isPyPy;
  };
}
