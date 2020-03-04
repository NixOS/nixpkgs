{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "0.9.0";
  pname = "websockify";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nnalv0jkkj34hw6yb12lp6r6fj1ps9vkkyshjvx65y5xdwmnny3";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "WebSockets support for any application/server";
    homepage = https://github.com/kanaka/websockify;
    license = licenses.lgpl3;
  };

}
