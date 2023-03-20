{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20230122";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M4AYbHbnRDvG55AvfRpcdpK4MU/cM1RBqn0JzhsKgsk=";
  };

  vendorHash = "sha256-sJbWAytX3JhFbaTwZHgGNv9rPNTwn0v/bbeaIsfyBro=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
