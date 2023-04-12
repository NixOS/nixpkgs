{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spruce";
  version = "unstable-2022-02-10";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = pname;
    rev = "473931f33fceae90b3f5cfb7616c296343a9559b";
    sha256 = "sha256-TFyWkoAKmj3KH2pqhVKMtP6QKTtu0s7H5gNP+fotUzg=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-VeC5c/BgcxK3Qawb2QOhqtfTIgbQbrQj546zX6yPD+s=";

  meta = with lib; {
    description = "A BOSH template merge tool";
    homepage = "https://github.com/geofffranks/spruce";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
