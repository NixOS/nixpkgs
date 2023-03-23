{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BHx44ux+g642aTaV0Wlw/uz/3Vy4MJfuNffgqGDsb6I=";
  };

  vendorHash = "sha256-eVuEyQCO2/gufMJp8eUpC82wdJbbJsMKR1ZGv96C9mI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  # tests expect the source files to be a build repo
  doCheck = false;

  meta = with lib; {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = with maintainers; [ c0deaddict endocrimes sarcasticadmin techknowlogick developer-guy caarlos0 ];
    license = licenses.mit;
  };
}
