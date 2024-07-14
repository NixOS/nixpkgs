{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sentinels";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e+BwTX/hkl45fpLRhmms4vYZyStdTrIaifMeAm+f9LE=";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sentinels" ];

  meta = with lib; {
    homepage = "https://github.com/vmalloc/sentinels/";
    description = "Various objects to denote special meanings in python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
