{ stdenv, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "Unidecode";
  version = "1.0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b85354be8fd0c0e10adbf0675f6dc2310e56fda43fa8fe049123b6c475e52fb";
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
