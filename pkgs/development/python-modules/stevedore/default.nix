{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, pbr
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "stevedore";
  version = "4.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+CzJmh/1UjENGcN5gnwsZN2fhaOLzVVZ2yRwFhhnt4Y=";
  };

  propagatedBuildInputs = [
    pbr
    setuptools
    six
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  doCheck = false;
  pythonImportsCheck = [ "stevedore" ];

  meta = with lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://docs.openstack.org/stevedore/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
