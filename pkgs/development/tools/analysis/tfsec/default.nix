{ lib
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.60.1";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JbEqoPuvfG6SwG+uGsV5vy+d+cs/VoGCntq8oU48+y8=";
  };

  goPackagePath = "github.com/aquasecurity/tfsec";

  ldflags = [
    "-w"
    "-s"
    "-X ${goPackagePath}/version.Version=${version}"
  ];

  meta = with lib; {
    description = "Static analysis powered security scanner for terraform code";
    homepage = "https://github.com/aquasecurity/tfsec";
    license = licenses.mit;
    maintainers = with maintainers; [ fab marsam ];
  };
}
