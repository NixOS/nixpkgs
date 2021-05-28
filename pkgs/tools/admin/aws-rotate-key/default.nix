{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "aws-rotate-key";
  version = "1.0.6";

  goPackagePath = "github.com/Fullscreen/aws-rotate-key";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Fullscreen";
    repo = "aws-rotate-key";
    sha256 = "1w9704g1l2b0y6g6mk79g28kk0yaswpgljkk85d0i10wyxq4icby";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Easily rotate your AWS key";
    homepage = "https://github.com/Fullscreen/aws-rotate-key";
    license = licenses.mit;
    maintainers = [maintainers.mbode];
    platforms = platforms.unix;
  };
}
