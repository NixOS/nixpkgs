{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "websockify";

  src = fetchPypi {
    inherit pname version;
    sha256 = "547d3d98c5081f2dc2872a2e4a3aef33e0ee5141d5f6209204aab2f4a41548d2";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "WebSockets support for any application/server";
    homepage = https://github.com/kanaka/websockify;
    license = licenses.lgpl3;
  };

}
