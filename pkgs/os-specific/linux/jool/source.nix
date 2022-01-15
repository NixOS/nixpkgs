{ fetchFromGitHub }:

rec {
  version = "4.1.6";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "09avkiazpfxzrgr3av58jbina5x9jqvqhjkn39475pfhfhrlv9fv";
  };
}
