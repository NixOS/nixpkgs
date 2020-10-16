{ lib, buildPythonPackage, substituteAll, stdenv,
  fetchPypi, numpy, cython, freetype-py, fontconfig, libGL,
  setuptools_scm, setuptools-scm-git-archive
  }:

buildPythonPackage rec {
  pname = "vispy";
  version = "0.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90cc76e79ee16c839bca05753e0c5f9f1c1c57963f2d3b248e4afac0fd75df75";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      gl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    cython setuptools_scm setuptools-scm-git-archive
  ];

  propagatedBuildInputs = [
    numpy freetype-py fontconfig libGL
  ];

  doCheck = false;  # otherwise runs OSX code on linux.
  pythonImportsCheck = [ "vispy" ];

  meta = with lib; {
    homepage = "http://vispy.org/index.html";
    description = "Interactive scientific visualization in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
