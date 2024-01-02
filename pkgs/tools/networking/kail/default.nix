{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kail";
  version = "0.17.0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "sha256-i53pW2YcmHDrRPhRI3iUD+YvGCReNgEeSltv4ZNIObo=";
  };

  vendorHash = "sha256-haF136u6CmbWGuOlCpnGf9lBEeN92PYM6KBvWVOZ8Ws=";

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [ offline vdemeester ];
  };
}
