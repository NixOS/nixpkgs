{ lib, stdenv, fetchFromGitHub, buildPythonPackage, isPy3k, regex }:

buildPythonPackage rec {
  pname = "SoMaJo";
  version = "2.2.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ywdh1pfk0pgm64p97i9cwz0h9wggbp4shxp5l7kkqs2n2v5c6qg";
  };

  propagatedBuildInputs = [ regex ];

  # loops forever
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
