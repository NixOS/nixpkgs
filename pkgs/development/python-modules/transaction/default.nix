{ stdenv
, fetchPypi
, buildPythonPackage
, zope_interface
, mock
}:


buildPythonPackage rec {
  pname = "transaction";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nak7cwyavrc3pdr6nxp2dnhrkkv9ircaii765zrs3kkkzgwn5zr";
  };

  propagatedBuildInputs = [ zope_interface mock ];

  meta = with stdenv.lib; {
    description = "Transaction management";
    homepage = https://pypi.python.org/pypi/transaction;
    license = licenses.zpl20;
  };
}
