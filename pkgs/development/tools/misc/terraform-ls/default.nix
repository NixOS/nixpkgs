{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.32.6";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+1nmxjR1iVtQXjdsqXaYTh8kLGq9gqSDjt1drvR9KoY=";
  };

  vendorHash = "sha256-8taGEDJ+Qtw/4eOWYiWZmEbmCwqcFXYh3x/9wR3oBJ8=";

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
