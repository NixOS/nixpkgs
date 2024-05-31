{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vbz8rpNy6+iIr/WyegALSo4gRoDL2P1x/6lHg6Kvm/w=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-ZRKs/5JtsTjWL62RuQRwroA6TvTpJqkf6pOecvO3134=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
    mainProgram = "chamber";
  };
}
