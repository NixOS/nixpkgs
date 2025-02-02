{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "umodbus";
  version = "1.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AdvancedClimateSystems";
    repo = "uModbus";
    rev = "refs/tags/${version}";
    hash = "sha256-5IXadb5mjrMwr+L9S1iMN5kba5VGrzYt1p8nBvvLCh4=";
  };

  propagatedBuildInputs = [ pyserial ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "umodbus" ];

  meta = with lib; {
    description = "Implementation of the Modbus protocol";
    homepage = "https://github.com/AdvancedClimateSystems/uModbus/";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
