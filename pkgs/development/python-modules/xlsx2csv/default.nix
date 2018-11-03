{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c6c8fa6c2774224d03a6a96049e116822484dccfa3634893397212ebcd23866";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bitprophet/alabaster;
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };

}
