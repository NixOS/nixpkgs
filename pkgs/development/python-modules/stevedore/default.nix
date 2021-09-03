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
  version = "3.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18aaxj4nrki0bjgzmqxqy20m7763q1xmwishy6biicapgzdqxdar";
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
