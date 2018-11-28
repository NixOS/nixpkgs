{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "websockify";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v6pmamjprv2x55fvbdaml26ppxdw8v6xz8p0sav3368ajwwgcqc";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "WebSockets support for any application/server";
    homepage = https://github.com/kanaka/websockify;
    license = licenses.lgpl3;
  };

}
