{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-html5lib";
  version = "1.1.11.20250917";
  pyproject = true;

  src = fetchPypi {
    pname = "types_html5lib";
    inherit version;
    hash = "sha256-e1J0M3fzP5tP1zha+9LUV7iGTuUfkP8qeVrZ6MBTNzo=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "html5lib-stubs" ];

  meta = with lib; {
    description = "Typing stubs for html5lib";
    homepage = "https://pypi.org/project/types-html5lib/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
