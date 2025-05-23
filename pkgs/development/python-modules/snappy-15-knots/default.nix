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
    rev = "${version}_as_released";
    sha256 = "sha256-fhJhHZFf4XuW/0V6LOuV4qoFWke3oFP0KArDpXLWh9g=";
  };

  build-system = [ setuptools ];

  dependencies = [ snappy-manifolds ];

  pythonImportsCheck = [ "snappy_15_knots" ];

  meta = with lib; {
    description = "Database of snappy manifolds";
    homepage = "https://snappy.computop.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
