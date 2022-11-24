{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-dateutil";
  version = "2.8.19.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-python-dateutil";
    inherit version;
    hash = "sha256-5uMs4Y83dlsIxGYiKHvI2BNtwMVi2a1bj9FYxZlj16c=";
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
