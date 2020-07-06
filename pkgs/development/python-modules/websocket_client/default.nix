{ lib, buildPythonPackage, fetchPypi, isPy27
, six
, backports_ssl_match_hostname
}:

buildPythonPackage rec {
  version = "0.57.0";
  pname = "websocket_client";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010";
  };

  propagatedBuildInputs = [
    six
  ] ++ lib.optional isPy27 backports_ssl_match_hostname;

  meta = with lib; {
    description = "Websocket client for python";
    homepage = "https://github.com/websocket-client/websocket-client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
