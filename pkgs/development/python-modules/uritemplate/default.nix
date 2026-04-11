{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uritemplate";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SAwu0YCHiVWGMyPuoxsO3maHld4YJhf++cbKCebsnQ4=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "uritemplate" ];

  meta = {
    description = "Implementation of RFC 6570 URI templates";
    homepage = "https://github.com/python-hyper/uritemplate";
    changelog = "https://github.com/python-hyper/uritemplate/blob/${version}/HISTORY.rst";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
