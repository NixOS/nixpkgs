{ stdenv, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Unidecode";
  version = "0.04.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lfhp9c5xrbpjvbpr12ji52g1lx04404bzzdg6pvabhzisw6l2i8";
  };

  LC_ALL="en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/Unidecode/;
    description = "ASCII transliterations of Unicode text";
    license = licenses.gpl2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
