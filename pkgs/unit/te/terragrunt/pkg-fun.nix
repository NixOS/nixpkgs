{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GOYSFhKfe8+9YBNyfCEUDCMssH9cXZi1S/KJTqPgBhY=";
  };

  vendorHash = "sha256-niU6DGKNhSV+nm+8jIP//AItBu5eWTasyeL/ADvY2zA=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=v${version}"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terragrunt --help
    $out/bin/terragrunt --version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${version}";
    description = "A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
  };
}
