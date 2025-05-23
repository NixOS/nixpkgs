{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  cython,
  networkx,
  decorator,
  snappy-manifolds,
  knot-floer-homology,
  snappy-15-knots,
  include15CrossingKnots ? true,
}:

buildPythonPackage rec {
  pname = "spherogram";
  version = "2.3";

  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NlvRsy8C/Nem+iGcoxTE1BzjRKsNLvO17YBzVQmNZ9o=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    networkx
    decorator
    snappy-manifolds
    knot-floer-homology
  ] ++ lib.optionals include15CrossingKnots [ snappy-15-knots ];

  doCheck = true;

  pythonImportsCheck = [ "spherogram" ];

  meta = with lib; {
    description = "Spherical diagrams for 3-manifold topology";
    homepage = "https://snappy.computop.org/spherogram.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
