{ lib
, stdenv
, buildPythonPackage
, substituteAll
, fetchPypi
, cython
, fontconfig
, freetype-py
, hsluv
, kiwisolver
, libGL
, numpy
, setuptools-scm
, setuptools-scm-git-archive
}:

buildPythonPackage rec {
  pname = "vispy";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e482e68487f5384205d349f288580d6287fd690df4cdc3ad4c573afc39990f1";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      gl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    cython
    setuptools-scm
    setuptools-scm-git-archive
  ];

  buildInputs = [
    libGL
  ];

  propagatedBuildInputs = [
    fontconfig
    freetype-py
    hsluv
    kiwisolver
    numpy
  ];

  doCheck = false;  # otherwise runs OSX code on linux.

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

  meta = with lib; {
    homepage = "https://vispy.org/index.html";
    description = "Interactive scientific visualization in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
