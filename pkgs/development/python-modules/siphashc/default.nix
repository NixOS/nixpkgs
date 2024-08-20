{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "siphashc";
  version = "2.4.1";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "siphashc";
    inherit version;
    sha256 = "sha256-ptNpy7VkUXHbjvdir6v+eYOmtQ/j8XPXq4lj7ceS/5s=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "siphashc" ];

  meta = with lib; {
    description = "Python c-module for siphash";
    homepage = "https://github.com/WeblateOrg/siphashc";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
