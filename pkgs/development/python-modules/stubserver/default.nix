{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stubserver";
  version = "1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j9R7wpvb07FuN5EhIpE7xTSf26AniQZN4iLpxMjNYKA=";
  };

  build-system = [ setuptools ];

  # Tests are not shipped and the source not tagged
  doCheck = false;

  pythonImportsCheck = [ "stubserver" ];

  meta = {
    description = "Web and FTP server for use in unit and7or acceptance tests";
    homepage = "https://github.com/tarttelin/Python-Stub-Server";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
