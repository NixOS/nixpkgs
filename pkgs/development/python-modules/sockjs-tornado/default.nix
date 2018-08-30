{ lib, buildPythonPackage, fetchPypi, tornado }:

buildPythonPackage rec {
  pname = "sockjs-tornado";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16cff40nniqsyvda1pb2j3b4zwmrw7y2g1vqq78lp20xpmhnwwkd";
  };

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    homepage = https://github.com/mrjoes/sockjs-tornado/;
    description = "SockJS python server implementation on top of Tornado framework";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
