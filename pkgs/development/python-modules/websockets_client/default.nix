{ stdenv, buildPythonPackage, fetchPypi, six }:
buildPythonPackage rec {
  pname = "websocket_client";
  version = "0.54.0";

  src = fetchPypi {
    inherit version pname;
    sha256 = "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849";
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
