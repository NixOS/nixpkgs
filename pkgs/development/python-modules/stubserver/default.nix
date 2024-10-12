{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "stubserver";
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j9R7wpvb07FuN5EhIpE7xTSf26AniQZN4iLpxMjNYKA=";
  };

  # Tests are not shipped and the source not tagged
  doCheck = false;

  pythonImportsCheck = [ "stubserver" ];

  meta = with lib; {
    description = "Web and FTP server for use in unit and7or acceptance tests";
    homepage = "https://github.com/tarttelin/Python-Stub-Server";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
