{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "asciigraph";
  version = "0.5.2";

  goPackagePath = "github.com/guptarohit/asciigraph";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iVgJtxt0B6nMA3bieZ1CmZucwLMb5av6Wn5BMDRWfcI=";
  };

  meta = with lib; {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    license = licenses.bsd3;
    maintainers = [ maintainers.mmahut ];
  };
}
