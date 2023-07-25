{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shadowsocks-v2ray-plugin";
  version = "1.3.1";
  # Version 1.3.2 has runtime failures with Go 1.19
  # https://github.com/NixOS/nixpkgs/issues/219343
  # https://github.com/shadowsocks/v2ray-plugin/issues/292
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "v2ray-plugin";
    rev = "v${version}";
    sha256 = "0aq445gnqk9dxs1hkw7rvk86wg0iyiy0h740lvyh6d9zsqhf61wb";
  };

  vendorSha256 = "0vzd9v33p4a32f5ic9ir4g5ckis06wpdf07a649h9qalimxnvzfz";

  meta = with lib; {
    description = "Yet another SIP003 plugin for shadowsocks, based on v2ray";
    homepage = "https://github.com/shadowsocks/v2ray-plugin/";
    license = licenses.mit;
    maintainers = [ maintainers.ahrzb ];
    mainProgram = "v2ray-plugin";
  };
}

