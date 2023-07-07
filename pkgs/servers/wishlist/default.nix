{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wishlist";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
    sha256 = "sha256-O2ciXaWH2QSoqDTnDxmqwgK/BM5WHye8JHfw9+zZxZ4=";
  };

  vendorHash = "sha256-wZugmCP3IouZ9pw3NEAZcoqdABMGTVi/IcithQjVFW4=";

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
