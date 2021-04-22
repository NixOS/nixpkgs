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
  version = "3.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Olu9BlK/VSdIhx6qc6So3CiZeGvEl6KqH8tNzbDevu4=";
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
  };
}
