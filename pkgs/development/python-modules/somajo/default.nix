{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "somajo";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    rev = "v${version}";
    sha256 = "0ywdh1pfk0pgm64p97i9cwz0h9wggbp4shxp5l7kkqs2n2v5c6qg";
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
