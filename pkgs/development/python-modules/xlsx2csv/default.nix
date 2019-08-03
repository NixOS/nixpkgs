{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff4121d42d318f31f71b248f37acfc21455a7d897a3c117b578744c89bc34f6c";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bitprophet/alabaster;
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };

}
