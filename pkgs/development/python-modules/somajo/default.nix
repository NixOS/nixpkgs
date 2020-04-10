{ pkgs, stdenv, fetchFromGitHub, buildPythonPackage, isPy3k, regex }:

buildPythonPackage rec {
  pname = "SoMaJo";
  version = "2.0.5";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = pname;
    rev = "v${version}";
    sha256 = "01zvmqilnndh2b257z7bhcc7av5vhjm1g8gmdiiw15gcd2xfmqjs";
  };

  propagatedBuildInputs = [ regex ];

  meta = with stdenv.lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    license = licenses.gpl3;
    maintainers = with maintainers; [ danieldk ];
  };
}
