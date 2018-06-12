{ stdenv, buildPythonPackage, fetchPypi, six }:
buildPythonPackage rec {
  pname = "websocket_client";
  version = "0.48.0";

  src = fetchPypi {
    inherit version pname;
    sha256 = "18f1170e6a1b5463986739d9fd45c4308b0d025c1b2f9b88788d8f69e8a5eb4a";
  };

  prePatch = ''
    # ssl.match_hostname exists in python2.7 version maintained in nixpkgs,
    # the dependency is not necessary.
    sed -e "s/\['backports.ssl_match_hostname'\]/\[\]/" -i setup.py
  '';

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/liris/websocket-client;
    description = "Websocket client for python";
    license = licenses.lgpl2;
  };
}
