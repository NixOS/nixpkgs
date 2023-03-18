{ lib
, fetchPypi
, buildPythonPackage
, zope_interface
, mock
}:


buildPythonPackage rec {
  pname = "transaction";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZdCx6pLb58Tjsjf7a9i0Heoj10Wee92MOIC//a+RL6Q=";
  };

  propagatedBuildInputs = [ zope_interface mock ];

  meta = with lib; {
    description = "Transaction management";
    homepage = "https://pypi.python.org/pypi/transaction";
    license = licenses.zpl20;
  };
}
