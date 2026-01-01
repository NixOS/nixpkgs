{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "siphashc";
<<<<<<< HEAD
  version = "2.7";
=======
  version = "2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-ppRNc3aM9So6g0LunBka2UBFWQAvck9E4Ot6sOC96jM=";
=======
    sha256 = "sha256-eBXoSfUx1hiAThgeq7fhTDnShrfVMFpnODk4dNbigoE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "siphashc" ];

<<<<<<< HEAD
  meta = {
    description = "Python c-module for siphash";
    homepage = "https://github.com/WeblateOrg/siphashc";
    changelog = "https://github.com/WeblateOrg/siphashc/blob/${version}/CHANGES.rst";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ erictapen ];
=======
  meta = with lib; {
    description = "Python c-module for siphash";
    homepage = "https://github.com/WeblateOrg/siphashc";
    changelog = "https://github.com/WeblateOrg/siphashc/blob/${version}/CHANGES.rst";
    license = licenses.isc;
    maintainers = with maintainers; [ erictapen ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
