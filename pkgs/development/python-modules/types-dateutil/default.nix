{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-dateutil";
  version = "2.8.19";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-python-dateutil";
    inherit version;
    hash = "sha256-v9PrOcclOupLojsQ9psBfTCwE2YrtL5KtIsgu9dj8wk=";
  };

  pythonImportsCheck = [
    "dateutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
