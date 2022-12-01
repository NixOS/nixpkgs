{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.10.12";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KbKOaUwJEy/mT59yW0VhZ3MIWkXarCRY8cyNlaI51mQ=";
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
