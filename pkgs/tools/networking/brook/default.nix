{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20210701";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MYd9q1pjrdLbgIoIakHeBuCjlEjXib0CNivZiqk5hns=";
  };

  vendorSha256 = "sha256-iaaXLpzN69yHBcAi9GS+G7LupX/7VABo1XFNegk+i3Q=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
