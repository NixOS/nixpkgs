{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "siphashc";
  version = "2.6";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eBXoSfUx1hiAThgeq7fhTDnShrfVMFpnODk4dNbigoE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "siphashc" ];

  meta = with lib; {
    description = "Python c-module for siphash";
    homepage = "https://github.com/WeblateOrg/siphashc";
    changelog = "https://github.com/WeblateOrg/siphashc/blob/${version}/CHANGES.rst";
    license = licenses.isc;
    maintainers = with maintainers; [ erictapen ];
  };
}
