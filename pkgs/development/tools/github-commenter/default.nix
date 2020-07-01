{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "github-commenter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = version;
    sha256 = "0y7yw7x8gqfbkqdfrwd9lffx3rrp62nz1aa86liy2dja97dacpij";
  };

  goPackagePath = "github.com/cloudposse/${pname}";

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    license = licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
