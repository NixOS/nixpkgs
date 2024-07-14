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
    hash = "sha256-Av8lRms6RrGn2+R3NAsEJ3CsB43n6kdaYoWiinXrH6s=";
  };

  propagatedBuildInputs = [ tornado ];

  meta = with lib; {
    homepage = "https://github.com/mrjoes/sockjs-tornado/";
    description = "SockJS python server implementation on top of Tornado framework";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
