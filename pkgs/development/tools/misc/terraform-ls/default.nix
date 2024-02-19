{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.32.7";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gH0wJRf64XloBfnvtNdZlONESjxG5mS5Ok9HTX1PJUA=";
  };

  vendorHash = "sha256-YvzUdcCjkCApufLk5CZv6L/mIlOuo9qEBoxHOxv2Ljc=";

  ldflags = [ "-s" "-w" ];

  # There's a mixture of tests that use networking and several that fail on aarch64
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terraform-ls --help
    $out/bin/terraform-ls --version | grep "${version}"
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
