{ fetchFromGitHub }:

rec {
  version = "4.1.12";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "refs/tags/v${version}";
    hash = "sha256-NJitXmWWEEglg4jag0mRZlmbf5+0sT08/pCssry5zD0=";
  };
}
