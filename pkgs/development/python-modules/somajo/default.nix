{ lib, stdenv, fetchFromGitHub, buildPythonPackage, isPy3k, regex }:

buildPythonPackage rec {
  pname = "SoMaJo";
  version = "2.1.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = pname;
    rev = "v${version}";
    sha256 = "07jkkg5ph5m47xf8w5asy5930qcpy6p11j0admll2y6yjynd2b47";
  };

  propagatedBuildInputs = [ regex ];

  # loops forever
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ danieldk ];
  };
}
