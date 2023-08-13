{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc52";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-F3UNvt7OicZJVcUgn5dQb7KjH0k3QOYOYDLrVpI5D64=";
  };

  vendorHash = "sha256-KD75KHXrXXm5FMXeFInNTDsVsclyqTfsfQiB3Br+F1A=";

  doCheck = false;

  subPackages = [ "cmd/mtail" ];

  preBuild = ''
    go generate -x ./internal/vm/
  '';

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}
