{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "Unidecode";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bvrAkL+PKZcK/JDK9Nquh7FycJt4bLG02i0MBiRDHsw=";
  };

  LC_ALL="en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/Unidecode/";
    description = "ASCII transliterations of Unicode text";
    license = licenses.gpl2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
