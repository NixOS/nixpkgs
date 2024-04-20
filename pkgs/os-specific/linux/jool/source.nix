{ fetchFromGitHub }:

rec {
  version = "4.1.11";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "refs/tags/v${version}";
    hash = "sha256-fTYUdtU51/zOBbd568QtfUYnqWl+ZN9uSbE29tJC6UM=";
  };
}
