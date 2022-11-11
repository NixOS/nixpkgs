{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "infra";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "infrahq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0HCfJwgeLM4uLiXcaW+9FxMVgeDJG7Opr0dEj525npw=";
  };

  vendorSha256 = "sha256-wtzk5J9b1SbWkRRgPmVdxiMJdgPDwAtNOx6Uup7iakk=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Infra manages access to infrastructure such as Kubernetes";
    homepage = "https://github.com/infrahq/infra";
    changelog = "https://github.com/infrahq/infra/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
