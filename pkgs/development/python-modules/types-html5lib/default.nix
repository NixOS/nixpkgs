{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-webencodings,
}:

buildPythonPackage rec {
  pname = "types-html5lib";
  version = "1.1.11.20251117";
  pyproject = true;

  src = fetchPypi {
    pname = "types_html5lib";
    inherit version;
    hash = "sha256-Gmo6xTlKoSv1R/rl1e/5Hc7sRrbQfENn2bOaN/QvIBo=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-webencodings ];

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
