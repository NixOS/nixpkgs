{ lib, buildPythonPackage, fetchPypi, tornado }:

buildPythonPackage rec {
  pname = "sockjs-tornado";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c4bcf33c8a238bbab37d01da769bcf89e74ef6019bfa76ddbcb4d682d47187e";
  };

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    homepage = https://github.com/mrjoes/sockjs-tornado/;
    description = "SockJS python server implementation on top of Tornado framework";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
