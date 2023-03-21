{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20230401";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PVkdK1wcY3PaeixEG4StV1AmYPit6pQNErcALmV2LXc=";
  };

  vendorHash = "sha256-7h+rMfFFpcsfZa6tw/o0uRIDw4g3g+dwd9y2Ysg2NJc=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
