{ fetchFromGitHub }:

rec {
  version = "4.1.7";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "08z23mi6xkr6zzp0hzh1cppvl2y0177s0lnpxqbpy8jiii5fxw8f";
  };
}
