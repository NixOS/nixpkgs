{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z5G7oXthz1oP9h6IwKZrkG0waBurBpbOALGdcAuThnc=";
  };

  vendorHash = "sha256-c5FzeqC+uEnVT3TxXHzI4FFIdJvKQ2tgGQAwd1DE5eM=";

  meta = with lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
