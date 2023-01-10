{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QoFdcPfwbcX8rVqX5yHg0B7sIAKE3iLWzwLV991t7a0=";
  };

  CGO_ENABLED = 0;

  vendorSha256 = "sha256-ENsKm3D3URCrRUiqqebkgFS//2h9SlLbAQHdjisdGlE=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
