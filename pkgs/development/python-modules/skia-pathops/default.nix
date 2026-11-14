{
  lib,
  stdenv,
  buildPythonPackage,
  fetchpatch2,
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
  version = "0.9.2";
  pyproject = true;

  src = fetchPypi {
    pname = "skia_pathops";
    inherit version;
    hash = "sha256-S22EWfb0ppKCyyb8oMK7CzIcxYqb+cxleaUqOR7cAxk=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://salsa.debian.org/fonts-team/libskia/-/raw/6574ca599eab076a9cd5b8667f81aef0f67b3eeb/debian/patches/loong-build";
      stripLen = 1;
      extraPrefix = "src/cpp/skia-builder/skia/";
      hash = "sha256-pKbWDYfZKUTv9ADdCl5sVPFfWiUCUmS8MXSw3eZhqMI=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "build_cmd = [sys.executable, build_skia_py, build_dir]" \
        'build_cmd = [sys.executable, build_skia_py, "--no-fetch-gn", "--no-virtualenv", "--gn-path", "${gn}/bin/gn", build_dir]'
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
    maintainers = [ lib.maintainers.wegank ];
    # "The Skia team is not endian-savvy enough to support big-endian CPUs."
    badPlatforms = lib.platforms.bigEndian;
    # ERROR at //gn/BUILDCONFIG.gn:87:14: Script returned non-zero exit code.
    broken = isPyPy;
  };
}
