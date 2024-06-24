{
  lib,
  buildPythonPackage,
  fetchPypi,
  tornado,
}:

buildPythonPackage rec {
  pname = "sockjs-tornado";
  version = "1.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02ff25466b3a46b1a7dbe477340b042770ac078de7ea475a6285a28a75eb1fab";
  };

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    homepage = "https://github.com/mrjoes/sockjs-tornado/";
    description = "SockJS python server implementation on top of Tornado framework";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
