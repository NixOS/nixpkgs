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
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "5.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-pUU0rPm4m8ftJkgHATtQW/B/dNvkvPo30yvQY4cLCHw=";
=======
    hash = "sha256-LEKNIziXYnno6yGW96lJEJYNn3ui9B85iFEelcpEcCE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
