{
  lib,
  stdenv,
  buildPythonPackage,
  replaceVars,
  fetchPypi,
  cython,
  fontconfig,
  freetype-py,
  hsluv,
  kiwisolver,
  libGL,
  numpy,
  oldest-supported-numpy,
  packaging,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "vispy";
  version = "0.16.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uTwyyF0IwGro9eMXf5z9bEleF0XyEgt3eDCt7l2cNkg=";
  };

  patches = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (replaceVars ./library-paths.patch {
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      gl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [ libGL ];

  propagatedBuildInputs = [
    freetype-py
    hsluv
    kiwisolver
    numpy
    packaging
  ];

  doCheck = false; # otherwise runs OSX code on linux.

  pythonImportsCheck = [
    "vispy"
    "vispy.color"
    "vispy.geometry"
    "vispy.gloo"
    "vispy.glsl"
    "vispy.io"
    "vispy.plot"
    "vispy.scene"
    "vispy.util"
    "vispy.visuals"
  ];

  meta = {
    description = "Interactive scientific visualization in Python";
    homepage = "https://vispy.org/index.html";
    changelog = "https://github.com/vispy/vispy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ goertzenator ];
  };
}
