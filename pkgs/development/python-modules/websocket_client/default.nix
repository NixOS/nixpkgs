{ lib, buildPythonPackage, fetchPypi, isPy27
, six
, backports_ssl_match_hostname
}:

buildPythonPackage rec {
  version = "0.56.0";
  pname = "websocket_client";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fpxjyr74klnyis3yf6m54askl0h5dchxcwbfjsq92xng0455m8z";
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
