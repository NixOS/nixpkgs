{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "somajo";
  version = "2.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    rev = "refs/tags/v${version}";
    hash = "sha256-vO3wEM3WkPQqq+ureJY+cpRHQ4cOLPV6DukA5LOscEM=";
  };

  propagatedBuildInputs = [
    regex
  ];

  # loops forever
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "somajo"
  ];

  meta = with lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
