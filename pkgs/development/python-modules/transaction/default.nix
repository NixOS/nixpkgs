{
  lib,
  fetchPypi,
  buildPythonPackage,
  zope-interface,
  mock,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "transaction";
  version = "4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aANduRP2DRvhL2Vj0gHaqzbIPnY94ViZ/4M48m5eYvI=";
  };

  propagatedBuildInputs = [
    zope-interface
    mock
  ];

  pythonImportsCheck = [ "transaction" ];

  meta = with lib; {
    description = "Transaction management";
    homepage = "https://transaction.readthedocs.io/";
    changelog = "https://github.com/zopefoundation/transaction/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ ];
  };
}
