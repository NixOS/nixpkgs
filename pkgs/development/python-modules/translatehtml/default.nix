{ lib
, buildPythonPackage
, fetchPypi
, argostranslate
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "translatehtml";
  version = "1.5.2";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b30ceb8b6f174917e2660caf2d2ccbaa71d8d24c815316edf56b061d678820d";
  };

  propagatedBuildInputs = [
    argostranslate
    beautifulsoup4
  ];

  postPatch = ''
    ln -s */requires.txt requirements.txt

    substituteInPlace requirements.txt  \
      --replace "==" ">="
  '';

  # required for import check to work (argostranslate)
  env.HOME = "/tmp";

  pythonImportsCheck = [ "translatehtml" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Translate HTML using Beautiful Soup and Argos Translate.";
    homepage = "https://www.argosopentech.com";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
  };
}
