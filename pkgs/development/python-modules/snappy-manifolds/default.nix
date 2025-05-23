{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "snappy-manifolds";
  version = "1.2.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "snappy_manifolds";
    # release of version 1.2.1
    rev = "f63ac1535344d9a8f73b6e5f9269703bde4c6af3";
    hash = "sha256-vxG3z6zWzG4S11fBxYGn4/c2f2sWOCIrzT+R27TR144=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "snappy_manifolds" ];

  meta = with lib; {
    description = "Database of snappy manifolds";
    homepage = "https://snappy.computop.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ noiioiu ];
  };
}
