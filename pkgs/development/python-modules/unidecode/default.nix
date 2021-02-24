{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "Unidecode";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zbjdf7svnnvn928fxsr8rcp2rrc7hj78ssg6hi6k5bs71ysjwwd";
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
