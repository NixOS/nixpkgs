{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "slowaes-0.1a1";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/slowaes/${name}.tar.gz";
    sha256 = "83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09";
  };

  meta = {
    homepage = "http://code.google.com/p/slowaes/";
    description = "AES implemented in pure python";
    license = stdenv.lib.licenses.asl20;
  };
}
