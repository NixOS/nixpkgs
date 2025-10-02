{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  snappy-manifolds,
}:

buildPythonPackage rec {
  pname = "snappy-15-knots";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "snappy_15_knots";
    tag = "${version}_as_released";
    hash = "sha256-fhJhHZFf4XuW/0V6LOuV4qoFWke3oFP0KArDpXLWh9g=";
  };

  build-system = [ setuptools ];

  dependencies = [ snappy-manifolds ];

  pythonImportsCheck = [ "snappy_15_knots" ];

  meta = with lib; {
    description = "Database of snappy manifolds";
    homepage = "https://snappy.computop.org";
    changelog = "https://github.com/3-manifolds/snappy_15_knots/releases/tag/${src.tag}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ noiioiu ];
  };
}
