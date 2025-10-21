{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.28.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-Ztd+woPh3JB1JqRFEaEmJBGHI6OWw20/PdmFXLYUzhQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "awscrt-stubs" ];

  meta = with lib; {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
