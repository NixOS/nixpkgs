{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-webencodings,
}:

buildPythonPackage rec {
  pname = "types-html5lib";
  version = "1.1.11.20260518";
  pyproject = true;

  src = fetchPypi {
    pname = "types_html5lib";
    inherit version;
    hash = "sha256-TzPAh8sRGdZcTIDspDI8K1Afnq+K+WFri3Mu1Njq6Po=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-webencodings ];

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
