{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20230606";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F4muuU696YbKcPkpD1LAeyD8ghQAe65UdqV5wS1fATI=";
  };

  vendorHash = "sha256-uKlO1x5sGM8B1htmvRt9kND7tuH36iLN/Mev77vwZ6M=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
