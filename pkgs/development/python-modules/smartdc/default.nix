{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, http_signature
}:

buildPythonPackage rec {
  pname = "smartdc";
  version = "0.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36206f4fddecae080c66faf756712537e650936b879abb23a8c428731d2415fe";
  };

  propagatedBuildInputs = [ requests http_signature ];

  meta = with stdenv.lib; {
    description = "Joyent SmartDataCenter CloudAPI connector using http-signature authentication via Requests";
    homepage = https://github.com/atl/py-smartdc;
    license = licenses.mit;
  };

}
