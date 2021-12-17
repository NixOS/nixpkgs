{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v5RbStmQX7D+i+oyekilLPsl6lta5rkJV4Uf0mjIF8Y=";
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
