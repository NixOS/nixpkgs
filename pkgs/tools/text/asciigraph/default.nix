{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "asciigraph";
  version = "0.5.1";

  goPackagePath = "github.com/guptarohit/asciigraph";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aqf64b5d5lf9scvxdx5f3p0vvx5s59mrvr6hcjljg1prksah9ns";
  };

  meta = with lib; {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    license = licenses.bsd3;
    maintainers = [ maintainers.mmahut ];
  };
}
