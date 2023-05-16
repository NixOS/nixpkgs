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
, pythonOlder
, setuptools-scm
, setuptools-scm-git-archive
}:

buildPythonPackage rec {
  pname = "vispy";
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-3vcn528rZd7YhmSoPaUN2peWOWHBbxOk2FCr3UWTD5Q=";
=======
    hash = "sha256-FBwt3MwRWFVbyJ8JAQxLHXVEh+gWNXMz8x55WnFGoCQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    description = "Interactive scientific visualization in Python";
    homepage = "https://vispy.org/index.html";
    changelog = "https://github.com/vispy/vispy/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
