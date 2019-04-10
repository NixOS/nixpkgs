{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "slowaes";
  version = "0.1a1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09";
  };

  disabled = isPy3k;

  meta = with stdenv.lib; {
    homepage = "http://code.google.com/p/slowaes/";
    description = "AES implemented in pure python";
    license = with licenses; [ asl20 ];
  };

}
