{ stdenv
, fetchPypi
, buildPythonPackage
, zope_interface
, mock
}:


buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "transaction";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mab0r3grmgz9d97y8pynhg0r34v0am35vpxyvh7ff5sgmg3dg5r";
  };

  propagatedBuildInputs = [ zope_interface mock ];

  meta = with stdenv.lib; {
    description = "Transaction management";
    homepage = http://pypi.python.org/pypi/transaction;
    license = licenses.zpl20;
  };
}
