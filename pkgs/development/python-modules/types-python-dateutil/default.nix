{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.9.0.20240906";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lwbDtoKEwlrf/Ecxnsx5R+W7hrN3P4Q8c5Bv1Zi8F24=";
  };

  nativeBuildInputs = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
