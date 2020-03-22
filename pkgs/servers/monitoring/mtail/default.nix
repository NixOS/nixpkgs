{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc35";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    sha256 = "04hzr0cw0dq7hmqvp1lhm5wl239yrxmcpsl25sqk74wy06cgrrqd";
  };

  modSha256 = "0h3q1qd9a01wlfkk0yv74a4bk5nilpsppq522cv7kl8ysnrjh5yi";
  subPackages = [ "cmd/mtail" ];

  preBuild = ''
    go generate -x ./internal/vm/
  '';

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version}"
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}
