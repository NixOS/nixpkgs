{ lib, stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "teleconsole-${version}";
  version = "0.4.0";

  goPackagePath = "github.com/gravitational/teleconsole";

  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleconsole";
    rev = "93261ac31763bf6a0a31762c22f4cc6946a7c876";
    sha256 = "01552422n0bj1iaaw6pvg9l1qr66r69sdsngxbcdjn1xh3mj74sm";
  };

  goDeps = ./deps.nix;

  CGO_ENABLED = 1;
  buildFlags = "-ldflags";

  meta = with lib; {
    homepage = "https://www.teleconsole.com/";
    description = "Share your terminal session with people you trust";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.kimburgess ];
  };
}
