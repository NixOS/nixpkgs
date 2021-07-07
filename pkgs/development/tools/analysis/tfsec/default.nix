{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "tfsec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MK5cWRPGty7S4pkRZJRZF5qitoPM3im8JJW2J3yQqFo=";
  };

  goPackagePath = "github.com/tfsec/tfsec";

  ldflags = [
    "-w"
    "-s"
    "-X ${goPackagePath}/version.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/tfsec/tfsec";
    description = "Static analysis powered security scanner for your terraform code";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
