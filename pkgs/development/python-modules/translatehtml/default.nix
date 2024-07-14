{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  argostranslate,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "translatehtml";
  version = "1.5.2";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-azDOuLbxdJF+JmDK8tLMuqcdjSTIFTFu31awYdZ4gg0=";
  };

  patches = [
    # https://github.com/argosopentech/translate-html/pull/15
    (fetchpatch {
      url = "https://github.com/argosopentech/translate-html/commit/b1c2d210ec1b5fcd0eb79f578bdb5d3ed5c9963a.patch";
      hash = "sha256-U65vVuRodMS32Aw6PZlLwaCos51P5B88n5hDgJNMZXU=";
    })
  ];

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
    description = "Translate HTML using Beautiful Soup and Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
  };
}
