{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.20240311";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oo5/mNF9KxT7lWXTI4jkGfQQj1V6fZOaZjGZabK5nHo=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
