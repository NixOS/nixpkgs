{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "thrift";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "029jcdjdiw7pm1dllcvw3r4cg8542pf21yzr0fpnj49jan8w1xmp";
  };

  # No tests. Breaks when not disabling.
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Python bindings for the Apache Thrift RPC system";
    homepage = http://thrift.apache.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
  };
}
