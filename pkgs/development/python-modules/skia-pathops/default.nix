{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  isPyPy,
  ninja,
  setuptools-scm,
  setuptools,
  fetchPypi,
  gn,
  pytestCheckHook,
  cctools,
  xcodebuild,
}:

buildPythonPackage rec {
  pname = "skia-pathops";
  version = "0.8.0.post2";
  pyproject = true;

  src = fetchPypi {
    pname = "skia_pathops";
    inherit version;
    extension = "zip";
    hash = "sha256-niUs3rbE0WLoKYbTHb2JxnXRZ3y4AZwuE+YpXUpVcmk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "build_cmd = [sys.executable, build_skia_py, build_dir]" \
        'build_cmd = [sys.executable, build_skia_py, "--no-fetch-gn", "--no-virtualenv", "--gn-path", "${gn}/bin/gn", build_dir]'
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace src/cpp/skia-builder/skia/gn/skia/BUILD.gn \
      --replace "-march=armv7-a" "-march=armv8-a" \
      --replace "-mfpu=neon" "" \
      --replace "-mthumb" ""
    substituteInPlace src/cpp/skia-builder/skia/src/core/SkOpts.cpp \
      --replace "defined(SK_CPU_ARM64)" "0"
  ''
  +
    lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) # old compiler?
      ''
        patch -p1 <<EOF
        --- a/src/cpp/skia-builder/skia/include/private/base/SkTArray.h
        +++ b/src/cpp/skia-builder/skia/include/private/base/SkTArray.h
        @@ -492 +492 @@:
        -    static constexpr int kMaxCapacity = SkToInt(std::min(SIZE_MAX / sizeof(T), (size_t)INT_MAX));
        +    static constexpr int kMaxCapacity = SkToInt(std::min<size_t>(SIZE_MAX / sizeof(T), (size_t)INT_MAX));
        EOF
      '';

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
    xcodebuild
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pathops" ];

  meta = {
    description = "Python access to operations on paths using the Skia library";
    homepage = "https://github.com/fonttools/skia-pathops";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    # "The Skia team is not endian-savvy enough to support big-endian CPUs."
    badPlatforms = lib.platforms.bigEndian;
    # ERROR at //gn/BUILDCONFIG.gn:87:14: Script returned non-zero exit code.
    broken = isPyPy;
  };
}
