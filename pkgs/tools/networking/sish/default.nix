{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "06ckgxhnijs7yrj0hhwh1vk2fvapwn6wb44w3g6qs6n6fmqh92mb";
  };

  vendorSha256 = "0vfazbaiaqka5nd7imh5ls7k3asf1c17y081nzkban98svg3l3sj";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
