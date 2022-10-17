{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "infra";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "infrahq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4JygXCn+2FACflheiddLZhw53XANdvdzPeFw1YysmKI=";
  };

  vendorSha256 = "sha256-Z+x1QStDfFkHoh2cWK2vk3whItpBVgqRdk3utp26BJc=";

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
