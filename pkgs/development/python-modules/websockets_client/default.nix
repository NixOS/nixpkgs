{ stdenv, buildPythonPackage, fetchPypi, six }:
buildPythonPackage rec {
  pname = "websocket_client";
  version = "0.47.0";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0jb1446053ryp5p25wsr1hjfdzwfm04a6f3pzpcb63bfz96xqlx4";
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
