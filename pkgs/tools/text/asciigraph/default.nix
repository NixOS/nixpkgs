{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "asciigraph";
  version = "0.5.3";

  goPackagePath = "github.com/guptarohit/asciigraph";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GzFJT4LI1QZzghs9g2A+pqkTg68XC+m9F14rYpMxEXM=";
  };

  meta = with lib; {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    license = licenses.bsd3;
    maintainers = [ maintainers.mmahut ];
  };
}
