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
    sha256 = "726059c461b9ec4e69e5bead6680667a3db01bf2adf901f23e4031228a0f9f9f";
  };

  propagatedBuildInputs = [ zope_interface mock ];

  meta = with stdenv.lib; {
    description = "Transaction management";
    homepage = https://pypi.python.org/pypi/transaction;
    license = licenses.zpl20;
  };
}
