{ fetchFromGitHub }:

rec {
  version = "3.5.7";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "1qxhrchhm4lbyxkp6wm47a85aa4d9wlyy3kdijl8rarngvh8j1yx";
  };
}
