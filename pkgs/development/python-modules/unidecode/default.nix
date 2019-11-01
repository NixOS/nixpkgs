{ stdenv, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "Unidecode";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8";
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
