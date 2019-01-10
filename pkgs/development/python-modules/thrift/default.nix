{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d59ac4fdcb2c58037ebd4a9da5f9a49e3e034bf75b3f26d9fe48ba3d8806e6b";
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
