{ stdenv, buildPythonPackage, fetchPypi, six }:
buildPythonPackage rec {
  pname = "websocket_client";
  version = "0.51.0";

  src = fetchPypi {
    inherit version pname;
    sha256 = "030bbfbf29ac9e315ffb207ed5ed42b6981b5038ea00d1e13b02b872cc95e8f6";
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
