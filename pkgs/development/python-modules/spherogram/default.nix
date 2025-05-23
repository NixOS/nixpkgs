{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  networkx,
  decorator,
  knot-floer-homology,
  snappy-manifolds,
  snappy-15-knots,
  include15CrossingKnots ? true,
}:

buildPythonPackage rec {
  pname = "spherogram";
  version = "2.3";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NlvRsy8C/Nem+iGcoxTE1BzjRKsNLvO17YBzVQmNZ9o=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

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
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
