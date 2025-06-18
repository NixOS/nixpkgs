{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snappy-manifolds";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "snappy_manifolds";
    tag = "${version}_as_released";
    hash = "sha256-vxG3z6zWzG4S11fBxYGn4/c2f2sWOCIrzT+R27TR144=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "snappy_manifolds" ];

  meta = {
    description = "Database of snappy manifolds";
    changelog = "https://github.com/3-manifolds/snappy_manifolds/releases/tag/${src.tag}";
    homepage = "https://snappy.computop.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
}
