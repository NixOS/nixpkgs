{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  importlib-metadata,
  pbr,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "stevedore";
  version = "5.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rrk8pA4RFM6pPXOKbB42U5aYG7a7eMJwRbdYfJRzVE0=";
  };

  propagatedBuildInputs = [
    pbr
    setuptools
    six
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  doCheck = false;
  pythonImportsCheck = [ "stevedore" ];

  meta = with lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://docs.openstack.org/stevedore/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
