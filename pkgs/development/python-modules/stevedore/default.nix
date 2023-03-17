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
  version = "4.1.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f4rrbj+Q+WgywwG/8hp+te776JTIjFBkg9NVVl2IzBo=";
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
