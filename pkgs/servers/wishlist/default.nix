{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wishlist";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-ZffVc/nLWaiUhg0DcLfDTiGVuK0MCSOpBd2gVG2rT0c=";
  };

  vendorHash = "sha256-FUTyTdGqdzuObpYW1ZSnhj24+MJiYG1NmSU4BZ6SlHM=";

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
