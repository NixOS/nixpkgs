{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dGeOFrsqhW0+aQyB4f6pvv4ZBawqKX2+WRskDWoLS7E=";
  };

  vendorSha256 = "sha256-ifSfeJjrZI1Hrsq64zAGBiLVc8GKvq+Ddg26gQooyTs=";

  doCheck = false;

  meta = with lib; {
    description = "Official Equinix Metal CLI";
    homepage = "https://github.com/equinix/metal-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne nshalman ];
  };
}
