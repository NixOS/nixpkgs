{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  numpy,
  shapely,
  fiona,
  geopandas,
  geojson,
  altair,
  simplification,
  ipywidgets,
  pyshp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "topojson";
  version = "1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mattijn";
    repo = "topojson";
    rev = "refs/tags/v${version}";
    hash = "sha256-HhkO+YrfJ0qgCneJf4tLa7PjyFhSNg9HHi6eiz6b5UM=";
  };

  build-system = [ flit-core ];

  dependencies = [
    numpy
    shapely
    fiona
    geopandas
    geojson
    altair
    simplification
    ipywidgets
    pyshp
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "topojson" ];

  meta = {
    description = "Encode spatial data as topology in Python";
    homepage = "https://mattijn.github.io/topojson";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
