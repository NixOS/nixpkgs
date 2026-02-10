{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "umodbus";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "AdvancedClimateSystems";
    repo = "uModbus";
    tag = version;
    hash = "sha256-5IXadb5mjrMwr+L9S1iMN5kba5VGrzYt1p8nBvvLCh4=";
  };

  propagatedBuildInputs = [ pyserial ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "umodbus" ];

  meta = {
    description = "Implementation of the Modbus protocol";
    homepage = "https://github.com/AdvancedClimateSystems/uModbus/";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
