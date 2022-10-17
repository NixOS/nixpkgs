{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "65.4.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2QIdanBpCzTnvSlH56sQFnxkb78GJQjLVlgb4uKhYV4=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "setuptools-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
