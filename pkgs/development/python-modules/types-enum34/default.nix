{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-enum34";
  version = "1.1.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b5x2lkHQbXOlXhHBTTisdvzTfrVFznnOu27snVCmQRA=";
  };

  pythonImportsCheck = [ "enum-python2-stubs" ];

  meta = with lib; {
    description = "Typing stubs for enum34";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
