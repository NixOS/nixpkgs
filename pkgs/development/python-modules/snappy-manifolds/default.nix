{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snappy-manifolds";
  version = "1.2.1";

  pyproject = true;

  src = fetchPypi {
    pname = "snappy_manifolds";
    inherit version;
    sha256 = "sha256-+/Gv8LX0nL2Q/6CAgzQYIpwJDHG5Z36ioaPt/UQyzQE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "snappy_manifolds" ];

  meta = with lib; {

    description = "Database of snappy manifolds";
    homepage = "https://snappy.computop.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
