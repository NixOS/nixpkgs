{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20220401";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H6lH4LG7MhxQsGVs3CSVX9FEywONDrS5bsjzw5b5k/U=";
  };

  vendorSha256 = "sha256-3ndpmERtaLHuTMMUcq+OenBxgW3+qy/bZCiWRgI0L84=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
