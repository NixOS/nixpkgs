{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyusb,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "temperusb";
  version = "1.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PwKHT1zzVn+nmxO/R+aK+029WaaHBo7FyVV4eQtHhbM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyusb ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "temperusb" ];

  meta = {
    description = "Library to read TEMPer USB HID devices";
    homepage = "https://github.com/padelt/temper-python";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
