{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "lnch";
  version = "unstable-2021-02-10";

  goPackagePath = "github.com/oem/${pname}";

  src = fetchFromGitHub {
    owner = "oem";
    repo = pname;
    rev = "6ed336dd893afa071178b8ac6f6297d23fc55514";
    sha256 = "K2TV+mx6C3/REJyDpC6a/Zn/ZZFxkDMC3EnkveH6YNQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/oem/lnch";
    description = "Launches a process and moves it out of the process group";
    license = licenses.mit;
    platforms = with platforms; all;
  };
}
