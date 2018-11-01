{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "aws-rotate-key-${version}";
  version = "1.0.3";

  goPackagePath = "github.com/Fullscreen/aws-rotate-key";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Fullscreen";
    repo = "aws-rotate-key";
    sha256 = "15na7flc0vp14amaq3116a5glqlb4ydvdlzv0q7mwl73pc38zxn3";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Easily rotate your AWS key";
    homepage = https://github.com/Fullscreen/aws-rotate-key;
    license = licenses.mit;
    maintainers = [maintainers.mbode];
    platforms = platforms.unix;
  };
}
