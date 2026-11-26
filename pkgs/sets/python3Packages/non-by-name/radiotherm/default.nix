{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "radiotherm";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mhrivnak";
    repo = "radiotherm";
    rev = version;
    hash = "sha256-ei4T1SnyAhq7kAKqHKa+uBnlmMAE0jadrFRVQQ+7Z1w=";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "radiotherm" ];

  meta = {
    description = "Python library for Wifi Radiothermostat";
    homepage = "https://github.com/mhrivnak/radiotherm";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
