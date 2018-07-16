{ stdenv
, fetchPypi
, buildPythonPackage
, zope_interface
, mock
}:


buildPythonPackage rec {
  pname = "transaction";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2242070e437e5d555ea3df809cb517860513254c828f33847df1c5e4b776c7a";
  };

  propagatedBuildInputs = [ zope_interface mock ];

  meta = with stdenv.lib; {
    description = "Transaction management";
    homepage = https://pypi.python.org/pypi/transaction;
    license = licenses.zpl20;
  };
}
