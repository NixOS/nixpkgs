{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kail";
  version = "0.17.2";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "sha256-mUdb3f5GaD+3GceUOpIFHKgGqqollzCJ8/oUj/37xAU=";
  };

  vendorHash = "sha256-GOrw/5nDMTg2FKkzii7FkyzCxfBurnnQbfBF4nfSaJI=";

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [ offline vdemeester ];
  };
}
