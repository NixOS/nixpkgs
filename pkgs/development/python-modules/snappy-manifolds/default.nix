{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snappy-manifolds";
  version = "1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "snappy_manifolds";
    tag = "${version}_as_released";
    hash = "sha256-e+BoPvg0cuEqLq2f9ZPgqFMEYw7eeSEDkY42+l+kDCk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "snappy_manifolds" ];

  meta = {
    description = "Database of snappy manifolds";
    changelog = "https://github.com/3-manifolds/snappy_manifolds/releases/tag/${src.tag}";
    homepage = "https://snappy.computop.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
