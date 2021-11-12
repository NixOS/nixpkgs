{ lib, stdenv, fetchFromGitHub, buildPythonPackage, isPy3k, regex }:

buildPythonPackage rec {
  pname = "SoMaJo";
  version = "2.1.5";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = pname;
    rev = "v${version}";
    sha256 = "17v1vmbjwpxwql25vlbm7xsair7945ljmyaricxx8fd6fxvgn9rr";
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
