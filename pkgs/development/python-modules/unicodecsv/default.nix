{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.14.1";
  pname = "unicodecsv";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z7pdwkr6lpsa7xbyvaly7pq3akflbnz8gq62829lr28gl1hi301";
  };

  # ImportError: No module named runtests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Drop-in replacement for Python2's stdlib csv module, with unicode support";
    homepage = https://github.com/jdunck/python-unicodecsv;
    maintainers = with maintainers; [ koral ];
  };

}
