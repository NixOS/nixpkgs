{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "aws-rotate-key-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/Fullscreen/aws-rotate-key";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Fullscreen";
    repo = "aws-rotate-key";
    sha256 = "13q7rns65cj8b4i0s75dbswijpra9z74b462zribwfjdm29by5k1";
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
