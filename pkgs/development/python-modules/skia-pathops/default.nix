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
  version = "0.7.2";

  src = fetchPypi {
    pname = "skia-pathops";
    inherit version;
    extension = "zip";
    sha256 = "sha256-Gdhcmv77oVr5KxPIiJlk935jgvWPQsYEC0AZ6yjLppA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "build_cmd = [sys.executable, build_skia_py, build_dir]" \
        'build_cmd = [sys.executable, build_skia_py, "--no-fetch-gn", "--no-virtualenv", "--gn-path", "${gn}/bin/gn", build_dir]'
  '';

  nativeBuildInputs = [ cython ninja setuptools-scm ]
    ++ lib.optionals stdenv.isDarwin [ xcodebuild ];

  buildInputs = lib.optionals stdenv.isDarwin [ ApplicationServices OpenGL ];

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pathops" ];

  meta = {
    description = "Python access to operations on paths using the Skia library";
    homepage = "https://skia.org/dev/present/pathops";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.BarinovMaxim ];
    broken = stdenv.isDarwin && stdenv.isAarch64; # clang-11: error: the clang compiler does not support '-march=armv7-a'
  };
}
