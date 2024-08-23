{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.9.0.20240821";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lknR3Lb+8QRvsYvr6eoqoAKLFgkYUYw0WJpGBF9uvZg=";
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
