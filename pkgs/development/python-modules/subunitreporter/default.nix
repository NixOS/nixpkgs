{ stdenv, buildPythonPackage, fetchPypi, zope_interface, twisted, python-subunit }:

buildPythonPackage rec {
  pname = "subunitreporter";
  version = "19.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vdmpp5hln38npn173bfjnqhd9dapxv9r30mi3sfdgsdmy7f4ynn";
  };

  checkInputs = [ python-subunit ];
  propagatedBuildInputs = [ twisted zope_interface ];

  meta = with stdenv.lib; {
    homepage = https://github.com/LeastAuthority/subunitreporter;
    description = "A Twisted Trial reporter which emits Subunit v2 streams.";
    license = licenses.mit;
  };
}
