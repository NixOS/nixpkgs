{
  lib,
  fetchFromGitHub,
  python,
  buildPythonPackage,

  # build-time dependencies
  setuptools,
  cython,

  # runtime dependencies
  decorator,
  knot-floer-homology,
  networkx,
  snappy-15-knots,
  snappy-manifolds,
}:

buildPythonPackage {
  pname = "spherogram";
  version = "2.4-unstable-2026-01-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "spherogram";
    rev = "d1353546fda1d7dc130ae4e7046e30ebbcc8f4c8";
    hash = "sha256-4gKkAzNWtDSJD2xyCRVTdWcHU0IJg8imkvMJhbTUDFE=";
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

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m spherogram.test
    runHook postCheck
  '';

  meta = {
    description = "Spherical diagrams for 3-manifold topology";
    homepage = "https://snappy.computop.org/spherogram.html";
    # changelog = "https://github.com/3-manifolds/Spherogram/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
