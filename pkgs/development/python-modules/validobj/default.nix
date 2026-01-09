{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "validobj";
  version = "1.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dXUvInNYkl10zdGQhJ6h1JqCNlZ+VsvwnEMb2xj6qOA=";
  };

  nativeBuildInputs = [ flit ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "validobj" ];

  meta = {
    description = "Validobj is library that takes semistructured data (for example JSON and YAML configuration files) and converts it to more structured Python objects";
    homepage = "https://github.com/Zaharid/validobj";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
