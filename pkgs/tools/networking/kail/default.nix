{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kail";
  version = "0.16.1";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "sha256-x9m0NoZjCf/lBWcSGFbjlJIukL6KIYt56Q1hADS8N9I=";
  };

  vendorHash = "sha256-W+/vIq7qC+6apk+1GOWvmcwyyjFRkndq8X5m/lRYOu4=";

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [ offline vdemeester ];
  };
}
