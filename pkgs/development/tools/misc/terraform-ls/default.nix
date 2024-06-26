{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kVLB1ruWOWGmCyEgHj8wtA7GwbdKiCYo7n4anVyKM5Y=";
  };

  vendorHash = "sha256-Vwa3km9CAq3Zik7dXWeHOnkIbL0eAwuKJ+bkw2lDe5k=";

  ldflags = [
    "-s"
    "-w"
  ];

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
    mainProgram = "terraform-ls";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      mbaillie
      jk
    ];
  };
}
