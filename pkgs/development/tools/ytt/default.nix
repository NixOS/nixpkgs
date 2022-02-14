{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "ytt";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-ytt";
    rev = "v${version}";
    sha256 = "sha256-OzH974FowU68blLLi9l+o7JPSuY+9Bkz13Q10QOuHWA=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/ytt" ];

  meta = with lib; {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    homepage = "https://get-ytt.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
