{ lib, buildPythonPackage, fetchPypi, tornado }:

buildPythonPackage rec {
  pname = "sockjs-tornado";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec12b0c37723b0aac56610fb9b6aa68390720d0c9c2a10461df030c3a1d9af95";
  };

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    homepage = https://github.com/mrjoes/sockjs-tornado/;
    description = "SockJS python server implementation on top of Tornado framework";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
