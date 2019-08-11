{ fetchFromGitHub }:

rec {
  version = "4.0.0";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "1ivnx7ijqf41kxmi2bmsf9qfcv6b1rvag35754ddlndry3sgvimr";
  };
}
