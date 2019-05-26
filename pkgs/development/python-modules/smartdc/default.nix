{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, http_signature
}:

buildPythonPackage rec {
  pname = "smartdc";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ffd866fb98386324e189e24d4f7532f66c1b20eece35ca1a6cb4b2a2639fc85";
  };

  propagatedBuildInputs = [ requests http_signature ];

  meta = with stdenv.lib; {
    description = "Joyent SmartDataCenter CloudAPI connector using http-signature authentication via Requests";
    homepage = https://github.com/atl/py-smartdc;
    license = licenses.mit;
  };

}
