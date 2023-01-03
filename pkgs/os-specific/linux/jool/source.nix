{ fetchFromGitHub }:

rec {
  version = "4.1.8";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    hash = "sha256-b+1EM172NRnnTcbJOwBQfytIRuIr8zZBlKBBV/e7Ttg=";
  };
}
