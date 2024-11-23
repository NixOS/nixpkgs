{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-dateutil";
  version = "2.9.0.20240906";
  pyproject = true;

  src = fetchPypi {
    pname = "types-python-dateutil";
    inherit version;
    hash = "sha256-lwbDtoKEwlrf/Ecxnsx5R+W7hrN3P4Q8c5Bv1Zi8F24=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
