{ lib, buildPythonPackage, substituteAll, stdenv,
  fetchPypi, numpy, cython, freetype-py, fontconfig, libGL,
  setuptools-scm, setuptools-scm-git-archive
  }:

buildPythonPackage rec {
  pname = "vispy";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89533514ffe05b16dca142a0ca455a96d14de209a1620615b1d251fa28d54b9b";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      gl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    cython setuptools-scm setuptools-scm-git-archive
  ];

  propagatedBuildInputs = [
    numpy freetype-py fontconfig libGL
  ];

  doCheck = false;  # otherwise runs OSX code on linux.
  pythonImportsCheck = [ "vispy" ];

  meta = with lib; {
    homepage = "https://vispy.org/index.html";
    description = "Interactive scientific visualization in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
