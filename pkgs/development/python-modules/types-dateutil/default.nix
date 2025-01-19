{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-dateutil";
  version = "2.9.0.20241003";
  pyproject = true;

  src = fetchPypi {
    pname = "types-python-dateutil";
    inherit version;
    hash = "sha256-WMuFRJsqVtZoTkGu77TEKAYxJGoNoacZvb5vP7AxdEY=";
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
