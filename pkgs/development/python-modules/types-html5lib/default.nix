{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-html5lib";
  version = "1.1.11.20251014";
  pyproject = true;

  src = fetchPypi {
    pname = "types_html5lib";
    inherit version;
    hash = "sha256-zGKNYm4BEaJCamT18GHs/RE5WLaf9rPcDqrtI0e6lFU=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "html5lib-stubs" ];

  meta = {
    description = "Typing stubs for html5lib";
    homepage = "https://pypi.org/project/types-html5lib/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
