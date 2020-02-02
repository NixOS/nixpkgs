{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9af1c86bf73433afc6010ed376a6c6aca2b54099cc0d61895f640870a9ae7d89";
  };

  propagatedBuildInputs = [ six ];

  # No tests. Breaks when not disabling.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for the Apache Thrift RPC system";
    homepage = http://thrift.apache.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
  };

}
