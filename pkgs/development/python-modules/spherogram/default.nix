{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  networkx,
  decorator,
  knot-floer-homology,
  snappy-manifolds,
  snappy-15-knots,
  include15CrossingKnots ? true,
}:

buildPythonPackage {
  pname = "spherogram";
  version = "2.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "spherogram";
    # release of version 2.3
    rev = "8355b4087dfd211612d900ec990c28724115f124";
    hash = "sha256-uqc+3xS4xulXR0tZlNuyC5Zz5OztR6c4PZWpsvU+4Pw=";
  };

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    networkx
    decorator
    snappy-manifolds
    knot-floer-homology
  ] ++ lib.optionals include15CrossingKnots [ snappy-15-knots ];

  pythonImportsCheck = [ "spherogram" ];

  meta = with lib; {
    description = "Spherical diagrams for 3-manifold topology";
    homepage = "https://snappy.computop.org/spherogram.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ noiioiu ];
  };
}
