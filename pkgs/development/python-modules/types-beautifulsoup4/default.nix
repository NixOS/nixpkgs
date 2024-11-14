{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-html5lib,
}:

buildPythonPackage rec {
  pname = "types-beautifulsoup4";
  version = "4.12.0.20241020";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FYNw0I0M1Ei9EbEypQ/1J5I3pdS1g3vroHTeFSpRMFk=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-html5lib ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "bs4-stubs" ];

  meta = with lib; {
    description = "Typing stubs for beautifulsoup4";
    homepage = "https://pypi.org/project/types-beautifulsoup4/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
