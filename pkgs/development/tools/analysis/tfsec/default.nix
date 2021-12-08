{ lib
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.63.1";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-khAVb+uwr3qyAWjvMjPG//+FKQJ9qoVwmhsej++IQhs=";
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
