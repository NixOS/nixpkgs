{ lib
, buildPythonPackage
, fetchurl
, sphinx
}:

buildPythonPackage rec {
  pname = "tracing";
  version = "0.8";
  format = "setuptools";

  src = fetchurl {
    url = "http://code.liw.fi/debian/pool/main/p/python-tracing/python-tracing_${version}.orig.tar.gz";
    sha256 = "1l4ybj5rvrrcxf8csyq7qx52izybd502pmx70zxp46gxqm60d2l0";
  };

  buildInputs = [ sphinx ];

  # error: invalid command 'test'
  doCheck = false;

  meta = with lib; {
    homepage = "https://liw.fi/tracing/";
    description = "Python debug logging helper";
    license = licenses.gpl3;
    maintainers = [];
  };

}
