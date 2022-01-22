{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mT99flZAAhLSynD/8+fa74Mc3KK8pVs+OOFDYNSBzEE=";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
