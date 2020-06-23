{ lib, buildGoPackage, fetchFromGitHub }:

let
  version = "1.3.1";
in buildGoPackage {
  name = "v2ray-plugin-${version}";

  goPackagePath = "github.com/shadowsocks/v2ray-plugin";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "v2ray-plugin";
    rev = "v${version}";
    sha256 = "0aq445gnqk9dxs1hkw7rvk86wg0iyiy0h740lvyh6d9zsqhf61wb";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Yet another SIP003 plugin for shadowsocks, based on v2ray";
    homepage = "https://github.com/shadowsocks/v2ray-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmenke ];
  };
}
