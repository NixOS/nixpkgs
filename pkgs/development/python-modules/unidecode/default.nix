{ stdenv, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "Unidecode";
  version = "1.0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5";
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
