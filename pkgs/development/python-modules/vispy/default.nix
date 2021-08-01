{ lib, buildPythonPackage, substituteAll, stdenv,
  fetchPypi, numpy, cython, freetype-py, fontconfig, libGL,
  setuptools-scm, setuptools-scm-git-archive
  }:

buildPythonPackage rec {
  pname = "vispy";
  version = "0.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f3c4d00be9e6761c046d520a86693d78a0925d47eeb2fc095e95dac776f74ee";
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
