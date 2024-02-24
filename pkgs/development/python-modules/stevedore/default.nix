{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pbr
, setuptools
}:

buildPythonPackage rec {
  pname = "stevedore";
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rrk8pA4RFM6pPXOKbB42U5aYG7a7eMJwRbdYfJRzVE0=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  doCheck = false;

  pythonImportsCheck = [
    "stevedore"
  ];

  meta = with lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://docs.openstack.org/stevedore/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
