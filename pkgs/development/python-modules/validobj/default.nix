{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "validobj";
  version = "1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dXUvInNYkl10zdGQhJ6h1JqCNlZ+VsvwnEMb2xj6qOA=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "validobj" ];

  meta = {
    description = "Library that takes semistructured data (for example JSON and YAML configuration files) and converts it to more structured Python objects";
    homepage = "https://github.com/Zaharid/validobj";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
