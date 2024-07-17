{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sops";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4K09wLV1+TvYTtvha6YyGhjlhEldWL1eVazNwcEhi3Q=";
  };

  vendorHash = "sha256-iRgLspYhwSVuL0yarPdjXCKfjK7TGDZeQCOcIYtNvzA=";

  subPackages = [ "cmd/sops" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/getsops/sops/v3/version.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/getsops/sops";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${version}/CHANGELOG.rst";
    mainProgram = "sops";
    maintainers = with maintainers; [
      Scrumplex
      mic92
    ];
    license = licenses.mpl20;
  };
}
