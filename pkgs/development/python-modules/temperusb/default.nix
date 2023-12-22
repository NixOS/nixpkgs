{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyusb
}:

buildPythonPackage rec {
  pname = "temperusb";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PwKHT1zzVn+nmxO/R+aK+029WaaHBo7FyVV4eQtHhbM=";
  };

  propagatedBuildInputs = [
    pyusb
  ];

  # Module has no tests which are shipped and source is not tagged
  doCheck = false;

  pythonImportsCheck = [
    "temperusb"
  ];

  meta = with lib; {
    description = "Library to read TEMPer USB HID devices";
    homepage = "https://github.com/padelt/temper-python";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
