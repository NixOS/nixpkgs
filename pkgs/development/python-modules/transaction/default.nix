{ stdenv
, fetchPypi
, buildPythonPackage
, zope_interface
, mock
}:


buildPythonPackage rec {
  pname = "transaction";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17wz1y524ca07vr03yddy8dv0gbscs06dbdywmllxv5rc725jq3j";
  };

  propagatedBuildInputs = [ zope_interface mock ];

  meta = with stdenv.lib; {
    description = "Transaction management";
    homepage = https://pypi.python.org/pypi/transaction;
    license = licenses.zpl20;
  };
}
