{ lib, buildPythonPackage, fetchurl, tornado }:

buildPythonPackage rec {
  name = "sockjs-tornado-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://pypi/s/sockjs-tornado/${name}.tar.gz";
    sha256 = "16cff40nniqsyvda1pb2j3b4zwmrw7y2g1vqq78lp20xpmhnwwkd";
  };

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    homepage = http://github.com/mrjoes/sockjs-tornado/;
    description = "SockJS python server implementation on top of Tornado framework";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
