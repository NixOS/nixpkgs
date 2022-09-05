{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wishlist";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-Q2/F4/bPhPmwkbc7dulx4jubwdwiwVWMNBclO2qf8rU=";
  };

  vendorSha256 = "sha256-gmLPMar3ICZ14uxahQPkruKUoZbnvYAdu5IfO2pNEXM=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A single entrypoint for multiple SSH endpoints";
    homepage = "https://github.com/charmbracelet/wishlist";
    changelog = "https://github.com/charmbracelet/wishlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
