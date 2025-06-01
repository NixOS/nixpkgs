{ fetchFromGitHub }:

rec {
  version = "4.1.14";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "refs/tags/v${version}";
    hash = "sha256-fAs289FFdUnddkikm4ceA9d/w1qqqaWuPXmAiq3cIA8=";
  };
}
