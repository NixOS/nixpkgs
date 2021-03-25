{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "Unidecode";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a039f89014245e0cad8858976293e23501accc9ff5a7bdbc739a14a2b7b85cdc";
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
