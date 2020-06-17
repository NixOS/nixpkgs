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

  vendorSha256 = "1km3ldqz35lpkglp9n332vxr38xxfqyij1fi2qq0agyyydbvakj5";
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