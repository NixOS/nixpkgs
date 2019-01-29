{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ce45a87b61af6d3c24fed4221642de9115dc9cb9ea65887b0926fd0fab0a597";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bitprophet/alabaster;
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };

}
