{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x1HPr1xzByyNnuNr8B4vqdxw+EeFJsqse/FG1I/b0+g=";
  };
  vendorSha256 = "sha256-f/y2i/aPeiUBiUaoCyehO8835qtxJkJsSh9/RAowsLI=";

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
