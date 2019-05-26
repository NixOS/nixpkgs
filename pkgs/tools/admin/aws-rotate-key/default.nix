{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "aws-rotate-key-${version}";
  version = "1.0.4";

  goPackagePath = "github.com/Fullscreen/aws-rotate-key";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Fullscreen";
    repo = "aws-rotate-key";
    sha256 = "14bcs434646qdywws55r1a1v8ncwz8n0yljaa8zb5796pv4445wf";
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
