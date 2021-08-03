{ fetchFromGitHub }:

rec {
  version = "4.1.5";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "05dwz4q6v6azgpyj9dzwihnw1lalhhym116q2ya7spvgxzxi04ax";
  };
}
