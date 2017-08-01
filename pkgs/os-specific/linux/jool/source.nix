{ fetchFromGitHub }:

rec {
  version = "3.5.4";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "09b9zcxgmy59jb778lkdyslx777bpsl216kkivw0zwfwsgd4pyz5";
  };
}
