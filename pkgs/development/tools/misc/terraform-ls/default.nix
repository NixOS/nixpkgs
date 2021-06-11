{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JctiWJ2HeFtrrOwCe1MCzxTkE2855FsgFocaAgK4fMk=";
  };
  vendorSha256 = "sha256-r4/WTzI1unvmjKOSJsaHVkws2/qWLuRrHLlzwckrm2Q=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X main.version=v${version} -X main.prerelease=")
  '';

  preCheck = ''
    # Remove test that requires networking
    rm internal/terraform/exec/exec_test.go
  '';

  meta = with lib; {
    description = "Terraform Language Server (official)";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mbaillie jk ];
  };
}
