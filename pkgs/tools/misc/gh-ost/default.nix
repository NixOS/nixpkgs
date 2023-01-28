{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gh-ost";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-ost";
    rev = "v${version}";
    sha256 = "sha256-FTWKbZ/32cr/BUI+jtV0HYlWDFz+R2YQd6ZSzilDj64=";
  };

  goPackagePath = "github.com/github/gh-ost";

  ldflags = [ "-s" "-w" "-X main.AppVersion=${version}" "-X main.BuildDescribe=${src.rev}" ];

  meta = with lib; {
    description = "Triggerless online schema migration solution for MySQL";
    homepage = "https://github.com/github/gh-ost";
    license = licenses.mit;
  };
}
