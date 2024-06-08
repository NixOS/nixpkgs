{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  scipy,
}:

buildPythonPackage {
  pname = "tess";
  version = "unstable-2019-05-07";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wackywendell";
    repo = "tess";
    rev = "22c19df952732f9749637d1bf6d7b676b6c7b26c";
    sha256 = "0pj18nrfx749fjc6bjdk5r3g1104c6jy6xg7jrpmssllhypbb1m4";
  };

  buildInputs = [ cython ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  meta = with lib; {
    description = "A module for calculating and analyzing Voronoi tessellations";
    homepage = "https://tess.readthedocs.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
