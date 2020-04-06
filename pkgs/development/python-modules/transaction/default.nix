{ stdenv
, fetchPypi
, buildPythonPackage
, zope_interface
, mock
}:


buildPythonPackage rec {
  pname = "transaction";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b0ad400cb7fa25f95d1516756c4c4557bb78890510f69393ad0bd15869eaa2d";
  };

  propagatedBuildInputs = [ zope_interface mock ];

  meta = with stdenv.lib; {
    description = "Transaction management";
    homepage = https://pypi.python.org/pypi/transaction;
    license = licenses.zpl20;
  };
}
