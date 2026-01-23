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
}:

buildPythonPackage rec {
  pname = "spherogram";
  version = "2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "spherogram";
    tag = "${version}_as_released";
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
  ];

  optional-dependencies.snappy-15-knots = [ snappy-15-knots ];

  pythonImportsCheck = [ "spherogram" ];

  meta = {
    description = "Spherical diagrams for 3-manifold topology";
    homepage = "https://snappy.computop.org/spherogram.html";
    changelog = "https://github.com/3-manifolds/Spherogram/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
