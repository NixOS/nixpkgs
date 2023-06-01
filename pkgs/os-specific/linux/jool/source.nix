{ fetchFromGitHub }:

rec {
  version = "4.1.9";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "refs/tags/v${version}";
    hash = "sha256-sKrjn/XQANiXfkjNiFfvAkmONyQjVigFBKgcGkuIPs0=";
  };
}
