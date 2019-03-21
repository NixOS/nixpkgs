{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f44k1q9jhn2iwabpj663l5wmm7zh6bp5402p659pxf11m8y4c2x";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bitprophet/alabaster;
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };

}
