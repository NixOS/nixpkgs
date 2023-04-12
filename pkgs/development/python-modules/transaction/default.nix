{ lib
, fetchPypi
, buildPythonPackage
, zope_interface
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "transaction";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZdCx6pLb58Tjsjf7a9i0Heoj10Wee92MOIC//a+RL6Q=";
  };

  propagatedBuildInputs = [
    zope_interface
    mock
  ];

  pythonImportsCheck = [
    "transaction"
  ];

  meta = with lib; {
    description = "Transaction management";
    homepage = "https://transaction.readthedocs.io/";
    changelog = "https://github.com/zopefoundation/transaction/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ ];
  };
}
