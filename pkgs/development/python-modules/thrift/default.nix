{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfbc3d3bd19d396718dab05abaf46d93ae8005e2df798ef02e32793cd963877e";
  };

  # No tests. Breaks when not disabling.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for the Apache Thrift RPC system";
    homepage = http://thrift.apache.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
  };

}
