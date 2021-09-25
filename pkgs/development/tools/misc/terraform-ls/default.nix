{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sfAn9FkOs9/yA7ciRD9gWbx5VwZveqPMYBQhSBkzYlo=";
  };
  vendorSha256 = "sha256-egv2+4esvfYccwmyHm23bec/QN6dGWvJVLG19959LPY=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" "-X main.prerelease=" ];

  # There's a mixture of tests that use networking and several that fail on aarch64
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terraform-ls --help
    $out/bin/terraform-ls version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Terraform Language Server (official)";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mbaillie jk ];
  };
}
