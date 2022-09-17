{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Rlill4T9zHdJUVk/46cPknaBXNN+PUGungqRdTMHFz4=";
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
