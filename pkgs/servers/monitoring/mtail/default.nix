{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc46";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    sha256 = "sha256-/PiwrXr/oG/euWDOqcXvKKvyvQbp11Ks8LjmmJjDtdU=";
  };

  vendorSha256 = "sha256-aBGJ+JJjm9rt7Ic90iWY7vGtZQN0u6jlBnAMy1nivQM=";

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
